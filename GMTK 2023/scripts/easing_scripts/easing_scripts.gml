function ease_linear(_t,_b,_c,_d){
#region
// Time, Begin, Change, Duration
// (inputvalue,outputmin,outputmax,inputmax)

_t = _t/_d; //You can also do t /= d

return _c*_t + _b;
#endregion
}

function ease_out_back(_t,_b,_c,_d){
#region 
// Time, Begin, Change, Duration
// (inputvalue,outputmin,outputmax,inputmax)

var _s = 1.70158; // constant

_t = _t/_d - 1;
return _c * (_t * _t * ((_s + 1) * _t + _s) + 1) + _b;
#endregion
}

function ease_out_elastic(_t,_b,_c,_d){
#region
var _s = 1.70158;
var _p = 0;
var _a = _c;

if (_t == 0 || _a == 0)
{
    return _b;
}

_t /= _d;

if (_t == 1)
{
    return _b + _c;
}

if (_p == 0)
{
    _p = _d * 0.3;
}

if (_a < abs(_c)) 
{ 
    _a = _c;
    _s = _p * 0.25; 
}
else 
{
    _s = _p / (2 * pi) * arcsin (_c / _a);
}

return _a * power(2, -10 * _t) * sin((_t * _d - _s) * (2 * pi) / _p ) + _c + _b;
#endregion
}

function ease_out_bounce(_t,_b,_c,_d){
#region
_t /= _d;

if (_t < 1/2.75)
{
    return _c * 7.5625 * _t * _t + _b;
}
else
if (_t < 2/2.75)
{
    _t -= 1.5/2.75;
    return _c * (7.5625 * _t * _t + 0.75) + _b;
}
else
if (_t < 2.5/2.75)
{
    _t -= 2.25/2.75;
    return _c * (7.5625 * _t * _t + 0.9375) + _b;
}
else
{
    _t -= 2.625/2.75;
    return _c * (7.5625 * _t * _t + 0.984375) + _b;
}
#endregion
}