// Copyright (c) 2024 Andrii Prokhorenko
// This file is part of Obmin, licensed under the MIT License.
// See the LICENSE file in the project root for license information.

import 'package:obmin/obmin.dart';

extension ResultOpticExtension<S, A, B> on Optic<S, Result<A, B>> {
  Optic<S, A> failure() {
    return then<A>(_resultFailureOptic<B, A>());
  }

  Optic<S, B> success() {
    return then<B>(_resultSuccessOptic<A, B>());
  }
}

extension ResultPathArrowExtension<Whole, A, B> on PathArrow<String, Whole, Result<A, B>> {
  PathArrow<String, Whole, A> failure() {
    return then<A>(_resultFailurePathArrow<B, A>());
  }

  PathArrow<String, Whole, B> success() {
    return then<B>(_resultSuccessPathArrow<A, B>());
  }
}

extension ResultOptionArrowExtension<Whole, A, B> on OptionArrow<Whole, Result<A, B>> {
  OptionArrow<Whole, A> failure() {
    return then<A>(_resultFailureOptionArrow<B, A>());
  }

  OptionArrow<Whole, B> success() {
    return then<B>(_resultSuccessOptionArrow<A, B>());
  }
}

PathArrow<String, Result<B, E>, B> _resultFailurePathArrow<E, B>() {
  return PathArrow.fromRun<String, Result<B, E>, B>((result) {
    return result.match<Path<String, B>>((value) {
      return Path.fromKeyValue("failure", value);
    }, constfunc(Path.empty<String, B>()));
  });
}

PathArrow<String, Result<E, B>, B> _resultSuccessPathArrow<E, B>() {
  return PathArrow.fromRun<String, Result<E, B>, B>((result) {
    return result.match<Path<String, B>>(constfunc(Path.empty<String, B>()), (value) {
      return Path.fromKeyValue("success", value);
    });
  });
}

OptionArrow<Result<E, B>, B> _resultSuccessOptionArrow<E, B>() {
  return OptionArrow.fromRun<Result<E, B>, B>((result) {
    return result.match<Option<B>>(constfunc(Option.none()), Option.some);
  });
}

OptionArrow<Result<B, E>, B> _resultFailureOptionArrow<E, B>() {
  return OptionArrow.fromRun<Result<B, E>, B>((result) {
    return result.match<Option<B>>(Option.some, constfunc(Option.none()));
  });
}

Optic<Result<E, Part>, Part> _resultSuccessOptic<E, Part>() {
  return Optic.fromPolyOptic<Result<E, Part>, Part>(_resultSuccessPolyOptic<E, Part, Part>());
}

Optic<Result<Part, E>, Part> _resultFailureOptic<E, Part>() {
  return Optic.fromPolyOptic<Result<Part, E>, Part>(_resultFailurePolyOptic<E, Part, Part>());
}

PolyOptic<Result<E, Part>, Result<E, TPart>, Part, TPart> _resultSuccessPolyOptic<E, Part, TPart>() {
  return PolyOptic.fromRun<Result<E, Part>, Result<E, TPart>, Part, TPart>((update) {
    return (functor) {
      return functor.rmap<TPart>(update);
    };
  });
}

PolyOptic<Result<Part, E>, Result<TPart, E>, Part, TPart> _resultFailurePolyOptic<E, Part, TPart>() {
  return PolyOptic.fromRun<Result<Part, E>, Result<TPart, E>, Part, TPart>((update) {
    return (functor) {
      return functor.lmap<TPart>(update);
    };
  });
}
