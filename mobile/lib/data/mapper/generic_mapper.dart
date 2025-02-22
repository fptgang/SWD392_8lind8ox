// import 'package:mobile/data/models/generic_response_model.dart';
//
// class GenericMapper<D, M> {
//   final M Function(D dto) toModel; // Function to convert DTO to Model
//
//   GenericMapper(this.toModel);
//
//   GenericResponseModel<M> toModels(D dto) {
//     return GenericResponseModel.fromDto<M, D>(
//       dto,
//           (list) => list.map((e) => toModel(e as D)).toList(),
//     );
//   }
// }
