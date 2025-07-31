import 'package:flutter/material.dart';
import 'step_data.dart';
import 'dotted_line_painter.dart';

class CustomStepper extends StatefulWidget {
  final List<StepData> steps;
  final VoidCallback onCompleted;
  final Color activeColor;
  final Color completedColor;
  final Color errorColor;

  const CustomStepper({
    super.key,
    required this.steps,
    required this.onCompleted,
    this.activeColor = Colors.blue,
    this.completedColor = Colors.green,
    this.errorColor = Colors.red,
  });

  @override
  State<CustomStepper> createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  int _currentStep = 0;
  final Set<int> _errorSteps = {};

  void _nextStep() {
    final formKey = widget.steps[_currentStep].formKey;
    if (formKey.currentState?.validate() ?? false) {
      setState(() {
        _errorSteps.remove(_currentStep);
        if (_currentStep < widget.steps.length - 1) {
          _currentStep++;
        } else {
          widget.onCompleted();
        }
      });
    } else {
      setState(() {
        _errorSteps.add(_currentStep);
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _onStepTapped(int index) {
    if (index <= _currentStep) {
      setState(() => _currentStep = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.steps[_currentStep];

    return Column(
      children: [
        _StepperHeader(
          steps: widget.steps,
          currentStep: _currentStep,
          onStepTapped: _onStepTapped,
          completedColor: widget.completedColor,
          activeColor: widget.activeColor,
          errorColor: widget.errorColor,
          errorSteps: _errorSteps,
        ),
        const SizedBox(height: 20),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Form(
            key: step.formKey,
            child: step.content,
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentStep > 0)
              ElevatedButton(
                onPressed: _previousStep,
                child: const Text("Back"),
              ),
            ElevatedButton(
              onPressed: _nextStep,
              child: Text(_currentStep == widget.steps.length - 1 ? "Finish" : "Next"),
            ),
          ],
        ),
      ],
    );
  }
}

class _StepperHeader extends StatelessWidget {
  final List<StepData> steps;
  final int currentStep;
  final void Function(int) onStepTapped;
  final Set<int> errorSteps;
  final Color activeColor;
  final Color completedColor;
  final Color errorColor;

  const _StepperHeader({
    required this.steps,
    required this.currentStep,
    required this.onStepTapped,
    required this.completedColor,
    required this.activeColor,
    required this.errorColor,
    required this.errorSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isOdd) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: CustomPaint(
                size: const Size(double.infinity, 2),
                painter: DottedLinePainter(
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          );
        } else {
          final stepIndex = index ~/ 2;
          final step = steps[stepIndex];
          final isActive = stepIndex == currentStep;
          final isCompleted = stepIndex < currentStep;
          final isError = errorSteps.contains(stepIndex);

          final bgColor = isError
              ? errorColor
              : isCompleted
              ? completedColor
              : isActive
              ? activeColor
              : Colors.grey.shade300;

          final fgColor = (isCompleted || isActive || isError)
              ? Colors.white
              : Colors.black;

          return GestureDetector(
            onTap: () => onStepTapped(stepIndex),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: bgColor,
                  child: step.icon != null
                      ? Icon(step.icon, size: 16, color: fgColor)
                      : Text('${stepIndex + 1}',
                      style: TextStyle(
                        fontSize: 14,
                        color: fgColor,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                const SizedBox(height: 4),
                Text(
                  step.title,
                  style: TextStyle(
                    fontSize: 12,
                    color: isActive ? activeColor : Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}