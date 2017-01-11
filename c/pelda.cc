#include <iostream>
#include <pqxx/pqxx>

using namespace std;
using namespace pqxx;

int main() {

	try {
		connection C("dbname=klokk user=##### password=##### hostaddr=127.0.0.1 port=5432");
		if (C.is_open()) {
			cout << "Az adatbázis elérése sikerült: " << C.dbname() << endl << endl;;
			char * sql;
			sql = "select * from kimitcsinal where nyitott";
			nontransaction N(C);
			result R(N.exec(sql));
			for(result::const_iterator c = R.begin(); c != R.end(); c++) {
				cout << c[0] << "\t" << c[1] << "\t" << c[2] << "\t" << c[3] << "\t" << c[4] << "\t" << c[5];
				cout << "\t" << c[6] << "\t" << c[7] << "\t" << c[8] << "\t" << c[9] << "\t" << c[10] << "\t";
				cout << c[11] << endl;
			}
		}
		else {
			cout << "Nem sikerült elérni az adatbázist: " << C.dbname() << endl;
			return 1;
		}
		C.disconnect();
		return 0;
	}
	catch (const std::exception &e){
		cerr << e.what() << std::endl;
		return 1;
	}
}
