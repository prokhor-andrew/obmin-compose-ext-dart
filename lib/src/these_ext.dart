// Copyright (c) 2024 Andrii Prokhorenko
// This file is part of Obmin, licensed under the MIT License.
// See the LICENSE file in the project root for license information.

import 'package:obmin/obmin.dart';

extension TheseOpticExtension<S, A, B> on Optic<S, These<A, B>> {
  Optic<S, B> right() {
    return then<B>(_theseRightOptic<A, B>());
  }

  Optic<S, A> left() {
    return then<A>(_theseLeftOptic<B, A>());
  }
}

extension ThesePathArrowExtension<Whole, A, B> on PathArrow<String, Whole, These<A, B>> {
  PathArrow<String, Whole, A> left() {
    return then<A>(_theseLeftPathArrow<B, A>());
  }

  PathArrow<String, Whole, B> right() {
    return then<B>(_theseRightPathArrow<A, B>());
  }
}

extension TheseOptionArrowExtension<Whole, A, B> on OptionArrow<Whole, These<A, B>> {
  OptionArrow<Whole, A> left() {
    return then<A>(_theseLeftOptionArrow<B, A>());
  }

  OptionArrow<Whole, B> right() {
    return then<B>(_theseRightOptionArrow<A, B>());
  }
}

PathArrow<String, These<E, B>, B> _theseRightPathArrow<E, B>() {
  return PathArrow.fromRun<String, These<E, B>, B>((these) {
    return these.match<Path<String, B>>(
      (left) => Path.empty<String, B>(),
      (right) {
        return Path.fromKeyValue("right", right);
      },
      (_, right) {
        return Path.fromKeyValue("right", right);
      },
    );
  });
}

PathArrow<String, These<B, E>, B> _theseLeftPathArrow<E, B>() {
  return PathArrow.fromRun<String, These<B, E>, B>((these) {
    return these.match<Path<String, B>>(
      (left) {
        return Path.fromKeyValue("left", left);
      },
      (right) => Path.empty<String, B>(),
      (left, _) {
        return Path.fromKeyValue("left", left);
      },
    );
  });
}

OptionArrow<These<E, B>, B> _theseRightOptionArrow<E, B>() {
  return OptionArrow.fromRun<These<E, B>, B>((these) {
    return these.match<Option<B>>(constfunc(Option.none()), Option.some, (_, right) {
      return Option.some(right);
    });
  });
}

OptionArrow<These<B, E>, B> _theseLeftOptionArrow<E, B>() {
  return OptionArrow.fromRun<These<B, E>, B>((these) {
    return these.match<Option<B>>(Option.some, constfunc(Option.none()), (left, _) {
      return Option.some(left);
    });
  });
}

Optic<These<E, Part>, Part> _theseRightOptic<E, Part>() {
  return Optic.fromPolyOptic<These<E, Part>, Part>(_theseRightPolyOptic<E, Part, Part>());
}

Optic<These<Part, E>, Part> _theseLeftOptic<E, Part>() {
  return Optic.fromPolyOptic<These<Part, E>, Part>(_theseLeftPolyOptic<E, Part, Part>());
}

PolyOptic<These<E, Part>, These<E, TPart>, Part, TPart> _theseRightPolyOptic<E, Part, TPart>() {
  return PolyOptic.fromRun<These<E, Part>, These<E, TPart>, Part, TPart>((update) {
    return (functor) {
      return functor.rmap<TPart>(update);
    };
  });
}

PolyOptic<These<Part, E>, These<TPart, E>, Part, TPart> _theseLeftPolyOptic<E, Part, TPart>() {
  return PolyOptic.fromRun<These<Part, E>, These<TPart, E>, Part, TPart>((update) {
    return (functor) {
      return functor.lmap<TPart>(update);
    };
  });
}
