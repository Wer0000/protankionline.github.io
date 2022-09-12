var serversMap = {
  RU1: 1,
  RU2: 2,
  RU3: 3,
  RU4: 4,
  RU5: 5,
  RU6: 6,
  RU7: 7,
  RU8: 8
};

var serversMapRev = flipArray(serversMap);
function flipArray(trans) {
    var key, tmp_ar = {};
    for (key in trans) {
	if (trans.hasOwnProperty(key)) {
	     tmp_ar[trans[key]] = key;
	}
    }
    return tmp_ar;
}
