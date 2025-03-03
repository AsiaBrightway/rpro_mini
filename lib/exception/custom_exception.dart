

import '../data/vos/error_vo.dart';

class CustomException implements Exception{

  final ErrorVo errorVo;

  CustomException(this.errorVo);

  @override
  String toString() => errorVo.message;
}