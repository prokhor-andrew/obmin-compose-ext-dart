// Copyright (c) 2024 Andrii Prokhorenko
// This file is part of Obmin, licensed under the MIT License.
// See the LICENSE file in the project root for license information.

import 'package:obmin/obmin.dart';

extension CallOpticExtension<S, A, B> on Optic<S, Call<A, B>> {
  Optic<S, A> launched() {
    return then<A>(_callLaunchedOptic<B, A>());
  }

  Optic<S, B> returned() {
    return then<B>(_callReturnedOptic<A, B>());
  }
}

extension CallPathArrowExtension<Whole, A, B> on PathArrow<String, Whole, Call<A, B>> {
  PathArrow<String, Whole, A> launched() {
    return then<A>(_callLaunchedPathArrow<B, A>());
  }

  PathArrow<String, Whole, B> returned() {
    return then<B>(_callReturnedPathArrow<A, B>());
  }
}

extension CallOptionArrowExtension<Whole, A, B> on OptionArrow<Whole, Call<A, B>> {
  OptionArrow<Whole, A> launched() {
    return then<A>(_callLaunchedOptionArrow<B, A>());
  }

  OptionArrow<Whole, B> returned() {
    return then<B>(_callReturnedOptionArrow<A, B>());
  }
}

// path arrow

PathArrow<String, Call<B, E>, B> _callLaunchedPathArrow<E, B>() {
  return PathArrow.fromRun<String, Call<B, E>, B>((call) {
    return call.match<Path<String, B>>((value) {
      return Path.fromKeyValue("launched", value);
    }, constfunc(Path.empty<String, B>()));
  });
}

PathArrow<String, Call<E, B>, B> _callReturnedPathArrow<E, B>() {
  return PathArrow.fromRun<String, Call<E, B>, B>((call) {
    return call.match<Path<String, B>>(constfunc(Path.empty<String, B>()), (value) {
      return Path.fromKeyValue("returned", value);
    });
  });
}

OptionArrow<Call<E, B>, B> _callReturnedOptionArrow<E, B>() {
  return OptionArrow.fromRun<Call<E, B>, B>((call) {
    return call.match<Option<B>>(constfunc(Option.none()), Option.some);
  });
}

OptionArrow<Call<B, E>, B> _callLaunchedOptionArrow<E, B>() {
  return OptionArrow.fromRun<Call<B, E>, B>((call) {
    return call.match<Option<B>>(Option.some, constfunc(Option.none()));
  });
}

Optic<Call<E, Part>, Part> _callReturnedOptic<E, Part>() {
  return Optic.fromPolyOptic<Call<E, Part>, Part>(_callReturnedPolyOptic<E, Part, Part>());
}

Optic<Call<Part, E>, Part> _callLaunchedOptic<E, Part>() {
  return Optic.fromPolyOptic<Call<Part, E>, Part>(_callLaunchedPolyOptic<E, Part, Part>());
}

PolyOptic<Call<E, Part>, Call<E, TPart>, Part, TPart> _callReturnedPolyOptic<E, Part, TPart>() {
  return PolyOptic.fromRun<Call<E, Part>, Call<E, TPart>, Part, TPart>((update) {
    return (functor) {
      return functor.rmap<TPart>(update);
    };
  });
}

PolyOptic<Call<Part, E>, Call<TPart, E>, Part, TPart> _callLaunchedPolyOptic<E, Part, TPart>() {
  return PolyOptic.fromRun<Call<Part, E>, Call<TPart, E>, Part, TPart>((update) {
    return (functor) {
      return functor.lmap<TPart>(update);
    };
  });
}
