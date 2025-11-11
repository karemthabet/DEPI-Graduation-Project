import 'package:flutter/material.dart';

class VisitIndicator extends StatefulWidget {
  final bool isLast;
  final bool initialCompleted;
  final ValueChanged<bool>? onChanged; 

  const VisitIndicator({
    Key? key,
    this.isLast = false,
    this.initialCompleted = false,
    this.onChanged, 
  }) : super(key: key);

  @override
  _VisitIndicatorState createState() => _VisitIndicatorState();
}

class _VisitIndicatorState extends State<VisitIndicator> {
  late bool isCompleted;

  @override
  void initState() {
    super.initState();
    isCompleted = widget.initialCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isCompleted = !isCompleted;
              widget.onChanged?.call(isCompleted); 
            });
          },
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? Color(0xFF4CAF50) : Colors.white,
              border: Border.all(
                color: isCompleted ? Color(0xFF4CAF50) : Color(0xFFE0E0E0),
                width: 2,
              ),
            ),
            child: isCompleted
                ? Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
        ),
        if (!widget.isLast)
          Container(
            width: 2,
            height: 120,
            color: Color(0xFF9E9E9E),
          ),
      ],
    );
  }
}