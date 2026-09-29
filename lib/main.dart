import 'package:flutter/material.dart';

void main() {
runApp(const CounterApp());
}

// APP SHELL
class CounterApp extends StatelessWidget {
const CounterApp({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false,
title: 'Activity 05 Counter',
theme: ThemeData(
colorScheme: ColorScheme.fromSeed(
seedColor: Colors.deepPurple,
brightness: Brightness.dark,
),
scaffoldBackgroundColor: const Color(0xFF0B1020),
useMaterial3: true,
),
home: const CounterHomePage(),
);
}
}

// COUNTER SCREEN
class CounterHomePage extends StatefulWidget {
const CounterHomePage({super.key});

@override
State<CounterHomePage> createState() => _CounterHomePageState();
}

class _CounterHomePageState extends State<CounterHomePage> {
// Starting counter value.
int _counter = 40;

// Amount added/subtracted each time.
int _increment = 7;

// Counter boundaries.
static const int _minimum = 10;
static const int _maximum = 150;

// Keeps track of previous counter values for Undo.
final List<int> _history = [];

// Text field controller for custom increment.
final TextEditingController _incrementController =
TextEditingController(text: '7');

// Returns the color for the current counter value.
Color _counterColor() {
// Red at the minimum / lower threshold.
if (_counter <= 24) {
return Colors.redAccent;
}

// Green at 90% or higher.
if (_counter > 90) {
return Colors.greenAccent;
}

// Normal state.
return Colors.white;
}

// Changes the counter.
void _moveTo(int nextValue) {
if (nextValue < _minimum || nextValue > _maximum) {
return;
}

if (nextValue == _counter) {
return;
}

setState(() {
_history.add(_counter);
_counter = nextValue;
});
}

// Changes the counter using the increment.
void _changeCounter(int amount) {
final int newValue = _counter + amount;

if (newValue < _minimum || newValue > _maximum) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text(
'Counter must stay between 10 and 150.',
),
),
);
return;
}

setState(() {
_history.add(_counter);
_counter = newValue;
});
}

// Undo the most recent change.
void _undo() {
if (_history.isEmpty) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('Nothing to undo.'),
),
);
return;
}

setState(() {
_counter = _history.removeLast();
});
}

// Reset everything.
void _reset() {
setState(() {
_history.clear();
_counter = 40;
_increment = 7;
_incrementController.text = '7';
});
}

// Save custom increment.
void _saveIncrement() {
final int? value = int.tryParse(
_incrementController.text.trim(),
);

if (value == null || value <= 0 || value > 50) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text(
'Enter an increment between 1 and 50.',
),
),
);
return;
}

setState(() {
_increment = value;
});

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(
'Increment set to $_increment.',
),
),
);
}

@override
void dispose() {
_incrementController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
final double progress =
(_counter - _minimum) / (_maximum - _minimum);

return Scaffold(
appBar: AppBar(
title: const Text(
'Counter Control',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
centerTitle: true,
backgroundColor: Colors.transparent,
),

body: SafeArea(
child: SingleChildScrollView(
padding: const EdgeInsets.all(20),

child: Column(
children: [

// ==========================================
// MAIN COUNTER CARD
// ==========================================
Container(
width: double.infinity,
padding: const EdgeInsets.all(28),

decoration: BoxDecoration(
gradient: const LinearGradient(
colors: [
Color(0xFF171D35),
Color(0xFF10162B),
],
begin: Alignment.topLeft,
end: Alignment.bottomRight,
),

borderRadius: BorderRadius.circular(28),

border: Border.all(
color: Colors.white.withOpacity(0.08),
),

boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.35),
blurRadius: 20,
offset: const Offset(0, 10),
),
],
),

child: Column(
children: [

const Text(
'CURRENT VALUE',
style: TextStyle(
letterSpacing: 2,
fontSize: 13,
fontWeight: FontWeight.bold,
color: Colors.white60,
),
),

const SizedBox(height: 10),

// Counter changes color at thresholds.
Text(
'$_counter',
style: TextStyle(
fontSize: 72,
fontWeight: FontWeight.w800,
color: _counterColor(),
),
),

const SizedBox(height: 16),

// Main progress bar.
ClipRRect(
borderRadius: BorderRadius.circular(20),

child: LinearProgressIndicator(
value: progress,
minHeight: 10,
backgroundColor: Colors.white12,
valueColor:
AlwaysStoppedAnimation<Color>(
_counterColor(),
),
),
),

const SizedBox(height: 10),

Text(
'Range: $_minimum – $_maximum',
style: const TextStyle(
color: Colors.white54,
),
),
],
),
),

const SizedBox(height: 12),

// ==========================================
// MAIN COUNTER SLIDER
// ==========================================
Container(
width: double.infinity,
padding: const EdgeInsets.symmetric(
horizontal: 18,
vertical: 14,
),

decoration: BoxDecoration(
color: const Color(0xFF12182D),
borderRadius: BorderRadius.circular(22),

border: Border.all(
color: Colors.white.withOpacity(0.07),
),
),

child: Column(
children: [

Row(
mainAxisAlignment:
MainAxisAlignment.spaceBetween,

children: [
const Text(
'COUNTER CONTROL',
style: TextStyle(
fontSize: 12,
letterSpacing: 1.5,
fontWeight: FontWeight.bold,
color: Colors.white60,
),
),

Text(
'$_counter',
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
color: _counterColor(),
),
),
],
),

const SizedBox(height: 6),

// Main slider controls the COUNTER.
SliderTheme(
data: SliderTheme.of(context).copyWith(
trackHeight: 8,

thumbShape:
const RoundSliderThumbShape(
enabledThumbRadius: 13,
),

overlayShape:
const RoundSliderOverlayShape(
overlayRadius: 28,
),

activeTrackColor:
_counterColor(),

inactiveTrackColor:
Colors.white24,

thumbColor: _counterColor(),

overlayColor:
_counterColor().withOpacity(0.25),
),

child: Slider(
value: _counter.toDouble(),

min: _minimum.toDouble(),
max: _maximum.toDouble(),

divisions:
_maximum - _minimum,

label: '$_counter',

onChanged: (double value) {
_moveTo(value.round());
},
),
),

// Threshold labels.
Row(
mainAxisAlignment:
MainAxisAlignment.spaceBetween,

children: [
const Text(
'10',
style: TextStyle(
color: Colors.redAccent,
fontWeight: FontWeight.bold,
),
),

const Text(
'10% threshold',
style: TextStyle(
color: Colors.redAccent,
fontSize: 11,
),
),

const Text(
'90%+',
style: TextStyle(
color: Colors.greenAccent,
fontWeight: FontWeight.bold,
),
),
],
),
],
),
),

const SizedBox(height: 20),

// ==========================================
// INCREMENT CONTROL
// ==========================================
Container(
width: double.infinity,
padding: const EdgeInsets.all(20),

decoration: BoxDecoration(
color: const Color(0xFF12182D),
borderRadius: BorderRadius.circular(22),

border: Border.all(
color: Colors.white.withOpacity(0.07),
),
),

child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,

children: [

const Text(
'CUSTOM INCREMENT',
style: TextStyle(
fontSize: 12,
letterSpacing: 1.5,
fontWeight: FontWeight.bold,
color: Colors.white60,
),
),

const SizedBox(height: 12),

Row(
children: [

Expanded(
child: TextField(
controller:
_incrementController,

keyboardType:
TextInputType.number,

decoration: InputDecoration(
hintText: 'Enter value',

filled: true,

fillColor:
Colors.white
    .withOpacity(0.05),

border:
OutlineInputBorder(
borderRadius:
BorderRadius.circular(14),

borderSide:
BorderSide.none,
),
),

onSubmitted: (_) =>
_saveIncrement(),
),
),

const SizedBox(width: 10),

FilledButton(
onPressed: _saveIncrement,
child: const Text('Set'),
),
],
),

const SizedBox(height: 10),

Center(
child: Text(
'Current increment: $_increment',
style: const TextStyle(
color: Colors.white60,
fontSize: 14,
),
),
),
],
),
),

const SizedBox(height: 20),

// ==========================================
// PLUS / MINUS BUTTONS
// ==========================================
Row(
children: [

Expanded(
child: SizedBox(
height: 58,

child: FilledButton.icon(
onPressed: () =>
_changeCounter(-_increment),

icon: const Icon(
Icons.remove,
),

label: Text(
'$_increment',

style: const TextStyle(
fontSize: 17,
fontWeight: FontWeight.bold,
),
),
),
),
),

const SizedBox(width: 14),

Expanded(
child: SizedBox(
height: 58,

child: FilledButton.icon(
onPressed: () =>
_changeCounter(_increment),

icon: const Icon(
Icons.add,
),

label: Text(
'$_increment',

style: const TextStyle(
fontSize: 17,
fontWeight: FontWeight.bold,
),
),
),
),
),
],
),

const SizedBox(height: 14),

// ==========================================
// UNDO + RESET
// ==========================================
Row(
children: [

Expanded(
child: OutlinedButton.icon(
onPressed: _undo,

icon: const Icon(
Icons.undo,
),

label: const Text(
'Undo',
),
),
),

const SizedBox(width: 14),

Expanded(
child: OutlinedButton.icon(
onPressed: _reset,

icon: const Icon(
Icons.restart_alt,
),

label: const Text(
'Reset',
),
),
),
],
),

const SizedBox(height: 24),

// ==========================================
// HISTORY
// ==========================================
Container(
width: double.infinity,
padding: const EdgeInsets.all(20),

decoration: BoxDecoration(
color: const Color(0xFF12182D),

borderRadius:
BorderRadius.circular(22),

border: Border.all(
color:
Colors.white.withOpacity(0.07),
),
),

child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,

children: [

Row(
mainAxisAlignment:
MainAxisAlignment.spaceBetween,

children: [

const Text(
'HISTORY',

style: TextStyle(
fontSize: 12,
letterSpacing: 1.5,
fontWeight: FontWeight.bold,
color: Colors.white60,
),
),

Text(
'${_history.length} changes',

style: const TextStyle(
color: Colors.white54,
),
),
],
),

const SizedBox(height: 12),

if (_history.isEmpty)

const Text(
'No previous values yet.',

style: TextStyle(
color: Colors.white38,
),
)

else

Wrap(
spacing: 8,
runSpacing: 8,

children:
_history.reversed
    .take(8)
    .map(
(value) => Chip(
label:
Text('$value'),
),
)
    .toList(),
),
],
),
),

const SizedBox(height: 20),

const Text(
'Midnight Aurora • Activity 05',

style: TextStyle(
color: Colors.white38,
fontSize: 12,
),
),
],
),
),
),
);
}
}

