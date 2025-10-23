// Copyright (c) 2024 Andrii Prokhorenko
// This file is part of Obmin, licensed under the MIT License.
// See the LICENSE file in the project root for license information.

import 'package:obmin/obmin.dart';

extension OptionOpticExtension<S, A> on Optic<S, Option<A>> {
  Optic<S, A> some() {
    return then<A>(_optionSomeOptic<A>());
  }
}

extension OptionPathArrowExtension<Whole, A> on PathArrow<String, Whole, Option<A>> {
  PathArrow<String, Whole, A> some() {
    return then<A>(_optionSomePathArrow<A>());
  }
}

extension OptionOptionArrowExtension<Whole, A> on OptionArrow<Whole, Option<A>> {
  OptionArrow<Whole, A> some() {
    return then<A>(_optionSomeOptionArrow<A>());
  }
}

PathArrow<String, Option<B>, B> _optionSomePathArrow<B>() {
  return PathArrow.fromRun<String, Option<B>, B>((option) {
    return option.match(Path.empty<String, B>, (value) {
      return Path.fromKeyValue("some", value);
    });
  });
}

OptionArrow<Option<B>, B> _optionSomeOptionArrow<B>() {
  return OptionArrow.fromRun<Option<B>, B>(idfunc);
}

Optic<Option<Part>, Part> _optionSomeOptic<Part>() {
  return Optic.fromPolyOptic<Option<Part>, Part>(_optionSomePolyOptic<Part, Part>());
}

PolyOptic<Option<Part>, Option<TPart>, Part, TPart> _optionSomePolyOptic<Part, TPart>() {
  return PolyOptic.fromRun<Option<Part>, Option<TPart>, Part, TPart>((update) {
    return (functor) {
      return functor.rmap<TPart>(update);
    };
  });
}
