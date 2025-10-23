// Copyright (c) 2024 Andrii Prokhorenko
// This file is part of Obmin, licensed under the MIT License.
// See the LICENSE file in the project root for license information.

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:obmin/obmin.dart';

extension IMapOpticExtension<Key, S, A> on Optic<S, IMap<Key, A>> {
  Optic<S, A> each() {
    return then<A>(_dictEachOptic<Key, A>());
  }

  Optic<S, A> at(Key key) {
    return then<A>(
      Optic.fromRun<IMap<Key, A>, A>((update) {
        return (whole) {
          if (!whole.containsKey(key)) {
            return whole;
          }
          final element = whole.get(key) as A;
          final updated = update(element);
          return whole.add(key, updated);
        };
      }),
    );
  }
}

extension IMapPathArrowExtension<Key, Whole, A> on PathArrow<String, Whole, IMap<Key, A>> {
  PathArrow<String, Whole, A> each() {
    return then<A>(_dictEachPathArrow<Key, A>());
  }

  PathArrow<String, Whole, A> at(Key key) {
    return then<A>(
      PathArrow.fromRun<String, IMap<Key, A>, A>((tuple) {
        final (map) = tuple;
        if (!map.containsKey(key)) {
          return Path.empty<String, A>();
        }

        final element = map.get(key) as A;

        return Path.fromKeyValue(key.toString(), element);
      }),
    );
  }
}

extension IMapOptionArrowExtension<Key, Whole, A> on OptionArrow<Whole, IMap<Key, A>> {
  OptionArrow<Whole, A> at(Key key) {
    return then<A>(
      OptionArrow.fromRun<IMap<Key, A>, A>((map) {
        if (!map.containsKey(key)) {
          return Option.none<A>();
        }

        final element = map.get(key) as A;

        return Option.some(element);
      }),
    );
  }
}

PathArrow<String, IMap<Key, B>, B> _dictEachPathArrow<Key, B>() {
  return PathArrow.fromRun<String, IMap<Key, B>, B>((map) {
    return Path.fromMap(map.map<IList<String>, B>((key, value) => MapEntry([key.toString()].lock, value)));
  });
}

Optic<IMap<Key, Part>, Part> _dictEachOptic<Key, Part>() {
  return Optic.fromPolyOptic<IMap<Key, Part>, Part>(_dictEachPolyOptic<Key, Part, Part>());
}

PolyOptic<IMap<Key, Part>, IMap<Key, TPart>, Part, TPart> _dictEachPolyOptic<Key, Part, TPart>() {
  return PolyOptic.fromRun<IMap<Key, Part>, IMap<Key, TPart>, Part, TPart>((update) {
    return (functor) {
      return functor.map<Key, TPart>((k, v) => MapEntry(k, update(v)));
    };
  });
}
