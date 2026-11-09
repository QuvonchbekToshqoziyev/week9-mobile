# Parts 1–3 lab notes

## Part 1

`CartLine` is immutable so each change creates a new value with `copyWith`.
Mutation can appear to work with `setState`, but it is a trap for provider and
bloc equality checks: reusing the same list or object can prevent listeners from
seeing a change and makes old state/history unsafe to retain.

`CartBody` receives callbacks so it remains a dumb, reusable view. It does not
know whether its parent uses `setState`, Riverpod, Cubit, or Bloc.

## Part 2

The setState history lives on the page's State object. Hot reload preserves the
State object, while hot restart recreates the application and clears it.
After checkout, a second page cannot read this private cart; the state would
need to move to shared scope such as a provider or a shared repository.

The summary values are getters because storing `total` separately could leave
it stale after a line, quantity, or coupon changes.

## Part 3

`ref.watch(cartProvider)` subscribes the page to the complete cart state.
`ref.watch(cartProvider.select((state) => state.total))` subscribes the summary
only to total changes. `ref.read(cartProvider.notifier)` obtains mutation
methods without subscribing, and `ref.read(cartProvider)` is used by the
listener/summary for the current snapshot.

The Riverpod summary rebuilds less often than the setState summary because its
`select` projection ignores state changes that do not change `total`.
Checkout side effects belong in `ref.listen`, not in `build`; no widget
`mounted` guard is needed because the provider owns the async state.
