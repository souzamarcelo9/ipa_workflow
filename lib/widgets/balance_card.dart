import 'package:viska_erp_mobile/theme/colors.dart';
import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key, required this.balance});

  final String balance;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColor.primary,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColor.shadowColor.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(1, 1), // changes position of shadow
              ),
            ],
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2),
                BlendMode.dstATop,
              ),
              image: const AssetImage('assets/images/bgcard.png'),
            ),
          ),
          child: _buildBalance(),
        ),
        Positioned(top: 100, left: 0, right: 0, child: _buildAddButton())
      ],
    );
  }

  Widget _buildBalance() {
    return Column(
      children: [
        const SizedBox(
          height: 25,
        ),
        const Text(
          "Seu Saldo",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
           '\$ $balance',
          style: const TextStyle(
            color: AppColor.secondary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColor.secondary,
        shape: BoxShape.circle,
        border: Border.all(),
      ),
      child: const Icon(Icons.add),
    );
  }
}
