# LuaObservable
Rx Cold Observables for Lua
http://reactivex.io/documentation/observable.html

## Usage
Loading the module
```lua
local Observable = require "LuaObservable"
```

Defining an Observable instance
```lua
local exampleObservable = Observable(function (next, err, complete, closed)
    -- next: sends a value
    -- err: throws an error, you can also use the native "error" function
    -- complete: complete the observer
    -- closed: check if observer is closed
    
    -- optional: cleanup function that is called manually. 
    --- Returned by :subscribe
    return function ()
        
    end
end)
```
Subscribing to an Observable
```lua
local source = Observable(function (next, err, complete, closed)
    for i = 1, 10 do 
        next(i)
        if(closed()) then
            return;
        end
    end
    complete()
end)

local subscription = source:subscribe(print)
```
outputs:
```lua
1
2
3
4
5
6
7
8
9
10
```

To use the Observable operators:
```lua
    Observable.loadExtensions();
```

Turn a table into an Observable
```lua
Observable.from({1, 2, 3, 4, 5}):subscribe(print)
```

or pass an observable
```lua
Observable.from(Observable(function (next, err, complete, closed)
    for i = 10, 1, -1 do
        next(i)
        if(closed()) then
          return
        end
    end
    
    complete()
end):subscribe(print)
```

Pass a set of arguments as sequence
```lua
Observable.of(1, 2, 3, 4, 5):subscribe(print)
```

Other functions implemented:
  * ```Observable.empty()``` creates an Empty Observable (completed Observable).
  * ```Observable.never()``` creates an Observable that will not notify.
  * ```Observable.throw(err)``` creates an Observable that throws an error.
  * ```Observable.just(someValue)``` creates an Observable that emits a value then completes.
  * ```Observable.range(min, max)``` creates an Observable that generates a sequence of emissions given a range.
  * ```Observable.doRepeat(value, iterations)``` creates an Observable that emits the same value.
  * ```observable:doWhile(criteria)``` creates an Observable that repeats its sequence until a criteria fails.
  * ```observable:buffer(criteria)``` packs all the emissions of the Observable then emits that packed values every succesful criteria
  * ```observable:flatMap(mutator)``` turns all emissions into Observables that acts like a single Observable.
  * ```observable:flatMapLatest(mutator)``` same with flatMap except that any previous Observable will stop emitting if a new Observable is created.
  * ```observable:flatMapObserver(onNextMutator, onErrorMutator, onCompleteMutator)```
  * ```observable:concatMap(mutator)``` turns all emissions into Observables and enqueues the Observables next to each other.
  * ```observable:map(mutator)``` mutates all emissions
  * ```observable:pluck(key)``` if the emission is a table, emit the specific value.
  * ```observable:scan(handler, seed)``` similar to reduce, except that every time the value passes the handler, the result gets emited.
  * ```observable:distinct(comparator)``` emits all distinct values from the Observable.
  * ```observable:distinctUntilChanged(comparator)``` emits the values if it is different from the previously emited value.
  * ```observable:elementAt(index)``` emits the value at the nth-emission of the Observable
  * ```observable:filter(criteria)``` emits all values that passes the criteria
  * ```observable:first(criteria)``` emits the first value that passes the criteria then completes.
  * ```observable:single(criteria)``` similar to first, except that the value is emited after the source completes.
  * ```observable:find(criteria)``` similar to first, except that if nothing passes the criteria, the Observable emits nil.
  * ```observable:ignore()``` ignores all emissions but recognizes the errors and completion notifications.
  * ```observable:last(criteria, default)``` emits the last emission that passes the criteria after the source completes.
  * ```observable:skip(amount)``` skips the amount of emissions from the source before emiting the rest.
  * ```observable:skipLast(amount)``` emits the emissions that do not belong to the last amount of emissions.
  * ```observable:skipUntil(otherObservable)``` skips emissions until the other Observable emits a value.
  * ```observable:skipWhile(criteria)``` skips emissions until an emission fails the criteria.
  * ```observable:take(amount)``` emits only the first amount of emissions.
  * ```observable:takeLast(amount)``` emits the last amount of emissions.
  * ```observable:takeUntil(otherObservable)``` emit until the other Observable emits a value.
  * ```observable:takeWhile(criteria)``` emits until an emission fails the criteria.
  * ```observable:takeLastBuffer(amount)``` emits the last amount of emissions as a buffer.
  * ```observable:combineLatest(otherObservable, combinator)``` combines any recent emissions from both Observables then emits it.
  * ```observable:concat(...)``` concats Observables.
  * ```observable:withLatestFrom(otherObservable, combinator)``` combines any recent emissions from both Observables then emits it every time the source emits.
  * ```observable:merge(...)``` merges the source Observable with other observables.
  * ```observable:startWith(...)``` similar to ```Observable.of``` except that the source Observable emits after the sequence from the arguments have been emitted.
  * ```Observable.zip(..., combinator)``` emits all recently emitted new values by combining them.
  * ```Observable.forkJoin(...)``` emits only the last values from each Observables as a buffer.
  * ```observable:forkJoin(otherObservable, combinator)``` emits the last values from both Observables by combining.
  * ```observable:catch(handler)``` continues the source Observable after an error.
  * ```observable:onErrorResumeNext(handler)``` continues the source Observable after an error or completion.
  * ```observable:tap(onNext, onError, onComplete)``` attaches a set of observer functions
  * ```observable:tapOnNext(handler)```
  * ```observable:tapOnError(handler)```
  * ```observable:tapOnComplete(handler)```
  * ```observable:finally(handler)``` executes handler on error and on completion.
  * ```observable:all(criteria)``` emits true if all emissions passes criteria after completion, otherwise false before completion.
  * ```observable:sorted(comparator)``` checks if the sequence is sorted. emits false before completion if it is not sorted.
  * ```Observable.amb(...)``` emits the emissions of the first Observable to notify.
  * ```observable:contains(value)``` emits true if any sequence emited is that of the base value, otherwise false on completion.
  * ```observable:indexOf(value, start)``` emits the index of the first emission that is equal to the base value starting from a given index.
  * ```observable:findIndex(criteria)``` emits the index of the first emission that passes the criteria.
  * ```observable:isEmpty()``` emits true if the source completed without any emission.
  * ```observable:defaultIfEmpty(value)``` emits the value if the source completed without any emission, otherwise, the observable will mirror the source.
  * ```observable:average()``` emits the average of the sequence on completion.
  * ```observable:count()``` emits the number of emissions.
  * ```observable:max()``` emits the largest value from the emissions on completion.
  * ```observable:min()``` emits the smallest.
  * ```observable:sum()``` emits the total of the values.
  * ```observable:reduce(reductor)``` emits a single value on completion based on the accumulated values.
  * ```Observable.linear(start, step)``` emits an infinite sequence of numbers based on a linear growth (start + step*n).
  * ```Observable.exponential(start, step)``` emits an infinite sequence of numbers based on an exponential growth (start*step*n).
  * ```Observable.sieve(level)``` emits an infinite sequence of primes. Level defines the the number of cycles of primality.
  * ```Observable.fibonacci()``` emits an infinite sequence of fibonacci numbers.
  * ```Observable.generator(handler, start, step)``` emits an infinite sequence of values produced by the handler.
  
## Changelogs
1.1
  * Observables are now infinite-safe, i.e. using :take(n) on an infinite sequence of emissions.
  * Added ```concat`` operator.
  * Added some custom operators: ```linear```, ```exponential```, ```sieve```, ```fibonacci``` and ```generator```.
  
1.0
  * Release
