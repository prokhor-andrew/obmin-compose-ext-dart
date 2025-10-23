// Copyright (c) 2024 Andrii Prokhorenko
// This file is part of Obmin, licensed under the MIT License.
// See the LICENSE file in the project root for license information.

import 'package:obmin/obmin.dart';

extension EitherOpticExtension<S, A, B> on Optic<S, Either<A, B>> {
  Optic<S, A> left() {
    return then<A>(_eitherLeftOptic<B, A>());
  }

  Optic<S, B> right() {
    return then<B>(_eitherRightOptic<A, B>());
  }
}

extension EitherPathArrowExtension<Whole, A, B> on PathArrow<String, Whole, Either<A, B>> {
  PathArrow<String, Whole, A> left() {
    return then<A>(_eitherLeftPathArrow<B, A>());
  }

  PathArrow<String, Whole, B> right() {
    return then<B>(_eitherRightPathArrow<A, B>());
  }
}

extension EitherOptionArrowExtension<Whole, A, B> on OptionArrow<Whole, Either<A, B>> {
  OptionArrow<Whole, A> left() {
    return then<A>(_eitherLeftOptionArrow<B, A>());
  }

  OptionArrow<Whole, B> right() {
    return then<B>(_eitherRightOptionArrow<A, B>());
  }
}

PathArrow<String, Either<B, E>, B> _eitherLeftPathArrow<E, B>() {
  return PathArrow.fromRun<String, Either<B, E>, B>((either) {
    return either.match<Path<String, B>>((value) {
      return Path.fromKeyValue<String, B>("left", value);
    }, constfunc(Path.empty<String, B>()));
  });
}

PathArrow<String, Either<E, B>, B> _eitherRightPathArrow<E, B>() {
  return PathArrow.fromRun<String, Either<E, B>, B>((either) {
    return either.match<Path<String, B>>(constfunc(Path.empty<String, B>()), (value) {
      return Path.fromKeyValue<String, B>("right", value);
    });
  });
}

OptionArrow<Either<E, B>, B> _eitherRightOptionArrow<E, B>() {
  return OptionArrow.fromRun<Either<E, B>, B>((either) {
    return either.match<Option<B>>(constfunc(Option.none()), Option.some);
  });
}

OptionArrow<Either<B, E>, B> _eitherLeftOptionArrow<E, B>() {
  return OptionArrow.fromRun<Either<B, E>, B>((either) {
    return either.match<Option<B>>(Option.some, constfunc(Option.none()));
  });
}

Optic<Either<E, Part>, Part> _eitherRightOptic<E, Part>() {
  return Optic.fromPolyOptic<Either<E, Part>, Part>(_eitherRightPolyOptic<E, Part, Part>());
}

Optic<Either<Part, E>, Part> _eitherLeftOptic<E, Part>() {
  return Optic.fromPolyOptic<Either<Part, E>, Part>(_eitherLeftPolyOptic<E, Part, Part>());
}

PolyOptic<Either<E, Part>, Either<E, TPart>, Part, TPart> _eitherRightPolyOptic<E, Part, TPart>() {
  return PolyOptic.fromRun<Either<E, Part>, Either<E, TPart>, Part, TPart>((update) {
    return (functor) {
      return functor.rmap<TPart>(update);
    };
  });
}

PolyOptic<Either<Part, E>, Either<TPart, E>, Part, TPart> _eitherLeftPolyOptic<E, Part, TPart>() {
  return PolyOptic.fromRun<Either<Part, E>, Either<TPart, E>, Part, TPart>((update) {
    return (functor) {
      return functor.lmap<TPart>(update);
    };
  });
}
