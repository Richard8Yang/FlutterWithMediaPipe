import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:image/image.dart' as image_lib;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

// ignore: must_be_immutable
abstract class AiModel extends Equatable {
  AiModel({this.interpreter});

  final outputShapes = <List<int>>[];
  final outputTypes = <TfLiteType>[];

  Interpreter? interpreter;

  @override
  List<Object> get props => [];

  int get getAddress;

  Future<Interpreter> createInterpreterFromAsset(String assetName) async {
    if (Platform.isAndroid) {
      // TODO: try delegates: NnApi -> GPU -> CPU ??
      try {
        var interpreterOptions = InterpreterOptions()
          ..useNnApiForAndroid = true;
        final interpreter =
            await Interpreter.fromAsset(assetName, options: interpreterOptions);
        return interpreter;
      } catch (e) {
        try {
          final delegate = GpuDelegateV2();
          var interpreterOptions = InterpreterOptions()..addDelegate(delegate);
          final interpreter = await Interpreter.fromAsset(assetName,
              options: interpreterOptions);
          return interpreter;
        } catch (e) {
          final interpreter = await Interpreter.fromAsset(assetName,
              options: InterpreterOptions());
          return interpreter;
        }
      }
    } else if (Platform.isIOS) {
      // try delegates: CoreML -> GPU -> CPU
      try {
        final delegate = CoreMlDelegate();
        var interpreterOptions = InterpreterOptions()..addDelegate(delegate);
        final interpreter =
            await Interpreter.fromAsset(assetName, options: interpreterOptions);
        return interpreter;
      } catch (e) {
        try {
          final delegate = GpuDelegate();
          var interpreterOptions = InterpreterOptions()..addDelegate(delegate);
          final interpreter = await Interpreter.fromAsset(assetName,
              options: interpreterOptions);
          return interpreter;
        } catch (e) {
          final interpreter = await Interpreter.fromAsset(assetName,
              options: InterpreterOptions());
          return interpreter;
        }
      }
    } else {
      // other platforms, use CPU
      final interpreter =
          await Interpreter.fromAsset(assetName, options: InterpreterOptions());
      return interpreter;
    }
  }

  Future<void> loadModel();
  TensorImage getProcessedImage(TensorImage inputImage);
  Map<String, dynamic>? predict(image_lib.Image image);
}
