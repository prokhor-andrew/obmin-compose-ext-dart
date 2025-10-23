// Copyright (c) 2024 Andrii Prokhorenko
// This file is part of Obmin, licensed under the MIT License.
// See the LICENSE file in the project root for license information.

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:obmin/obmin.dart';

extension IListOpticExtension<S, A> on Optic<S, IList<A>> {
  Optic<S, A> each() {
    return then<A>(_listEachOptic<A>());
  }

  Optic<S, A> at(int index) {
    return then<A>(
      Optic.fromRun<IList<A>, A>((update) {
        return (whole) {
          if (index < 0 || index >= whole.length) {
            return whole;
          } else {
            final element = whole[index];
            final updated = update(element);
            return whole.replace(index, updated);
          }
        };
      }),
    );
  }
}

extension IListPathArrowExtension<Whole, A> on PathArrow<String, Whole, IList<A>> {
  PathArrow<String, Whole, A> each() {
    return then<A>(_listEachPathArrow<A>());
  }

  PathArrow<String, Whole, A> at(int index) {
    return then<A>(
      PathArrow.fromRun<String, IList<A>, A>((tuple) {
        final (list) = tuple;
        if (index < 0 || index >= list.length) {
          return Path.empty<String, A>();
        }

        return Path.fromKeyValue("$index", list[index]);
      }),
    );
  }
}

extension IListOptionArrowExtension<Whole, A> on OptionArrow<Whole, IList<A>> {
  OptionArrow<Whole, A> at(int index) {
    return then<A>(
      OptionArrow.fromRun<IList<A>, A>((list) {
        if (index < 0 || index >= list.length) {
          return Option.none<A>();
        }

        return Option.some(list[index]);
      }),
    );
  }
}

PathArrow<String, IList<B>, B> _listEachPathArrow<B>() {
  return PathArrow.fromRun<String, IList<B>, B>((list) {
    IMap<IList<String>, B> result = IMap<IList<String>, B>.empty();

    for (final tuple in list.indexed) {
      final (index, value) = tuple;
      result = result.add(["$index"].lock, value);
    }

    return Path.fromMap(result);
  });
}

Optic<IList<Part>, Part> _listEachOptic<Part>() {
  return Optic.fromPolyOptic<IList<Part>, Part>(_listEachPolyOptic<Part, Part>());
}

PolyOptic<IList<Part>, IList<TPart>, Part, TPart> _listEachPolyOptic<Part, TPart>() {
  return PolyOptic.fromRun<IList<Part>, IList<TPart>, Part, TPart>((update) {
    return (functor) {
      return functor.map<TPart>(update).toIList();
    };
  });
}
