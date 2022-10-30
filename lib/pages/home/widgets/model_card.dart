import 'package:flutter/material.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/data.dart';
import '../../../services/model_inference_service.dart';
import '../../../services/service_locator.dart';
import '../../camera/camera_page.dart';

class ModelCard extends StatelessWidget {
  const ModelCard({
    required this.index,
    required this.scale,
    Key? key,
  }) : super(key: key);

  final int index;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onTapCamera(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          image: DecorationImage(
            image: AssetImage(models[index]['image']!),
            fit: BoxFit.cover,
          ),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 10,//ScreenUtil().setWidth(10.0),
          vertical: 30 * scale,//ScreenUtil().setHeight(30.0) * scale,
        ),
        child: _ModelDescription(index: index),
      ),
    );
  }

  void _onTapCamera(BuildContext context) {
    locator<ModelInferenceService>().setModelConfig(index);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CameraPage(index: index);
        },
      ),
    );
  }
}

class _ModelDescription extends StatelessWidget {
  const _ModelDescription({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
            ),
          ),
          padding: const EdgeInsets.all(16/*ScreenUtil().setWidth(16.0)*/),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                models[index]['title']!,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 20,//ScreenUtil().setSp(20.0),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8,//ScreenUtil().setHeight(8.0),
              ),
              Text(
                models[index]['text']!,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,//ScreenUtil().setSp(12.0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
