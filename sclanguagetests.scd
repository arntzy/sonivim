//Supercollider Language Tests
s.boot;
currentEnvironment; //shows Environmental Variables set
this.dump; //shows interpreter variables set (a-z)
[this, this.class, thisMethod.name].postln;

(
~a = "TOP";
(a: "INNER") use: {
	currentEnvironment.postln;
	topEnvironment.postln;
	~a.postln
};
~a;
)

(
#p, q = [100, 400].collect {|i|
	Window(i.asString, Rect(i, i, 200, 200)).front
}
)
q.addUniqueMethod(\greet, {|w| w.name = "Hello!"});
greet(q); \\or...
q.greet;

QWindow.browse; //opens class browser
{1 + 1}.value; //evaluates a function

{3 + 5}.def.dumpByteCodes; //shows bytecode for function

(
var w_func;
w_func = { arg message = "warning!", bounds = Rect(200,500,500,100);
	var window;
	window = Window("message window", bounds).front;
	TextView(window, window.view.bounds.insetBy(10,10))
	.string = message;
};
w_func.("flipperpot", Rect(200, 300, 200, 200));
)

