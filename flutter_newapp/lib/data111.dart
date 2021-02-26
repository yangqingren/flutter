import 'package:json_annotation/json_annotation.dart';

part 'data111.g.dart';

@JsonSerializable()
class Data111 extends Object {
  @JsonKey(name: 'status')
  int status;

  @JsonKey(name: 'message')
  String message;

  Data111(
    this.status,
    this.message,
  );

  factory Data111.fromJson(Map<String, dynamic> srcJson) =>
      _$Data111FromJson(srcJson);

  Map<String, dynamic> toJson() => _$Data111ToJson(this);
}
