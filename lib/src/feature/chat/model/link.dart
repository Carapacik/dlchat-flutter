import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:rest_client/chat/dto/link_model_dto.dart';

@immutable
class const Link({required final String id, required final String title, required final String url}) {
  factory decode(LinkModelDto dto) => Link(id: dto.id, title: dto.title, url: dto.url);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Link && other.id == id && other.title == title && other.url == url;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ url.hashCode;

  Link copyWith({String? id, String? title, String? url}) =>
      Link(id: id ?? this.id, title: title ?? this.title, url: url ?? this.url);

  @override
  String toString() => 'Link{id: $id, title: $title, url: $url}';
}

final class const LinkConverter() extends Converter<Link, LinkModelDto> {
  @override
  LinkModelDto convert(Link input) => LinkModelDto(id: input.id, title: input.title, url: input.url);
}
