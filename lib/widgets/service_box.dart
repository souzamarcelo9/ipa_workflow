import 'package:viska_erp_mobile/theme/colors.dart';
import 'package:flutter/material.dart';

class ServiceBox extends StatelessWidget {
  const ServiceBox(this.icon, {
    super.key,
    //required this.icon,
    this.color,
    this.bgColor,
    required this.text ,
    required this.onPressed,
  });


  final IconData icon;
  final Color? color;
  final Color? bgColor;
  final String text;
  final VoidCallback onPressed;

  factory ServiceBox.expense({
    required VoidCallback onPressed, required Color bgColor,
  }) {
    return ServiceBox(
      text:'Cronograma',
      Icons.access_alarm,
      color: Colors.black,
      onPressed: onPressed,
      bgColor: bgColor,
    );
  }

  factory ServiceBox.revenue({
    required VoidCallback onPressed, required Color bgColor,
  }) {
    return ServiceBox(
      text:'Atividades',
      Icons.account_tree,
      color: Colors.black,
      onPressed: onPressed,
      bgColor: bgColor,
    );
  }

  factory ServiceBox.material({
    required VoidCallback onPressed, required Color bgColor,
  }) {
    return ServiceBox(
      text:'Solic.Material',
      Icons.handyman_rounded,
      color: Colors.black,
      onPressed: onPressed,
      bgColor: bgColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.secondary,
            ),
            child: TextButton(
              onPressed: onPressed,
              style: TextButton.styleFrom(
                foregroundColor:
                Colors.blueAccent,
              ),
              child: Icon(icon),
            ),
          ),
          const SizedBox(height: 13),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
