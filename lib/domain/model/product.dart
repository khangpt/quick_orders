import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@CopyWith()
@JsonSerializable(createToJson: false)
class Product extends Equatable {
  const Product({
    this.id,
    this.name,
    this.price,
    this.category,
    this.isPrescription = false,
    this.count = 0,
  });

  final int? id;
  final String? name;
  final double? price;
  final String? category;

  @JsonKey(defaultValue: false)
  final bool isPrescription;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final int count;

  @override
  List<Object?> get props => [id, name, price, category, isPrescription];

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}
