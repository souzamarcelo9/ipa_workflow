import 'package:flutter_modular/flutter_modular.dart';
import 'package:viska_erp_mobile/theme/colors.dart';
import 'package:flutter/material.dart';

import '../app/modules/home/store/home_store.dart';

class TransactionItem extends StatelessWidget {

  TransactionItem(this.data, {super.key, this.onTap});

  final data;
  final GestureTapCallback? onTap;
  final HomeStore controller = Modular.get();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
        decoration: BoxDecoration(
          color: controller.appStore.isDark ? AppColor.shadowColor : AppColor.secondary,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowColor.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(1, 1), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           // AvatarImage(
            //  data['image'],
            //  isSVG: false,
            //  width: 35,
             // height: 35,
             // radius: 50,
            //),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  _buildNameAndAmount(),
                  const SizedBox(height: 2),
                  _buildDateAndType(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateAndType() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          data.date,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        data.type == 1
            ? const Icon(
                Icons.download_rounded,
                color: AppColor.green,
              )
            : const Icon(
                Icons.upload_rounded,
                color: AppColor.red,
              ),
      ],
    );
  }

  Widget _buildNameAndAmount() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            data.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          data.price,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }
}
