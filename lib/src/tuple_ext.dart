// Copyright (c) 2024 Andrii Prokhorenko
// This file is part of Obmin, licensed under the MIT License.
// See the LICENSE file in the project root for license information.

import 'package:obmin/obmin.dart';

extension TupleOpticExtension<S, A, B> on Optic<S, (A, B)> {
  Optic<S, A> left() {
    return then<A>(_tupleLeftOptic<B, A>());
  }

  Optic<S, B> right() {
    return then<B>(_tupleRightOptic<A, B>());
  }
}

extension TuplePathArrowExtension<Whole, A, B> on PathArrow<String, Whole, (A, B)> {
  PathArrow<String, Whole, A> left() {
    return then<A>(_tupleLeftPathArrow<B, A>());
  }

  PathArrow<String, Whole, B> right() {
    return then<B>(_tupleRightPathArrow<A, B>());
  }
}

extension TupleOptionArrowExtension<Whole, A, B> on OptionArrow<Whole, (A, B)> {
  OptionArrow<Whole, A> left() {
    return then<A>(_tupleLeftOptionArrow<B, A>());
  }

  OptionArrow<Whole, B> right() {
    return then<B>(_tupleRightOptionArrow<A, B>());
  }
}

PathArrow<String, (E, B), B> _tupleRightPathArrow<E, B>() {
  return PathArrow.fromRun<String, (E, B), B>((tuple) {
    return Path.fromKeyValue("right", tuple.$2);
  });
}

PathArrow<String, (B, E), B> _tupleLeftPathArrow<E, B>() {
  return PathArrow.fromRun<String, (B, E), B>((tuple) {
    return Path.fromKeyValue("left", tuple.$1);
  });
}

OptionArrow<(E, B), B> _tupleRightOptionArrow<E, B>() {
  return OptionArrow.fromRun<(E, B), B>((tuple) {
    return Option.some(tuple.$2);
  });
}

OptionArrow<(B, E), B> _tupleLeftOptionArrow<E, B>() {
  return OptionArrow.fromRun<(B, E), B>((tuple) {
    return Option.some(tuple.$1);
  });
}

Optic<(E, Part), Part> _tupleRightOptic<E, Part>() {
  return Optic.fromPolyOptic<(E, Part), Part>(_tupleRightPolyOptic<E, Part, Part>());
}

Optic<(Part, E), Part> _tupleLeftOptic<E, Part>() {
  return Optic.fromPolyOptic<(Part, E), Part>(_tupleLeftPolyOptic<E, Part, Part>());
}

PolyOptic<(E, Part), (E, TPart), Part, TPart> _tupleRightPolyOptic<E, Part, TPart>() {
  return PolyOptic.fromRun<(E, Part), (E, TPart), Part, TPart>((update) {
    return (functor) {
      return functor.rmap<TPart>(update);
    };
  });
}

PolyOptic<(Part, E), (TPart, E), Part, TPart> _tupleLeftPolyOptic<E, Part, TPart>() {
  return PolyOptic.fromRun<(Part, E), (TPart, E), Part, TPart>((update) {
    return (functor) {
      return functor.lmap<TPart>(update);
    };
  });
}
