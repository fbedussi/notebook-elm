const COUNTER = 'counter'

const counterInitialValue = window.localStorage.getItem(COUNTER) || '0'

const app = Elm.Main.init({flags: Number(counterInitialValue)});

app.ports.setCounter.subscribe(counter => {
	window.localStorage.setItem(COUNTER, counter)
})

app.ports.getUserName.send('baz')
