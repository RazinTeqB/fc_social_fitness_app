import 'package:fc_social_fitness/utils/flutter_flow_theme.util.dart';
import 'package:fc_social_fitness/views/widgets/fitness_loading.widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import '../utils/flutter_flow.util.dart';
import '../viewmodels/diet.viewmodel.page.dart';

class DietPage extends StatefulWidget {
  @override
  _DietPageState createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeCompletoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  DateTime? _dataNascita;
  String? _genere;
  String? _motivoVisita;
  String? _esamiFuoriRange;
  String? _pratichiSport;
  final TextEditingController _sportController = TextEditingController();
  final TextEditingController _oreSportSettimanaController = TextEditingController();
  String? _fumi;
  String? _consumiAlcool;
  final TextEditingController _tipoAlcoolController = TextEditingController();
  final TextEditingController _volteAlcoolSettimanaController = TextEditingController();
  String? _consumoAcqua;
  String? _problemiIntestinali;
  final TextEditingController _tipoProblemiIntestinaliController = TextEditingController();
  String? _cicloRegolare;
  String? _assumiFarmaci;
  final TextEditingController _tipoFarmaciController = TextEditingController();
  String? _lavoroSedentario;
  final TextEditingController _tipoLavoroController = TextEditingController();
  String? _allergieAlimentari;
  final TextEditingController _tipoAllergieController = TextEditingController();
  String? _intolleranzeAlimentari;
  final TextEditingController _tipoIntolleranzeController = TextEditingController();
  String? _problemiStomaco;
  final TextEditingController _tipoProblemiStomacoController = TextEditingController();
  final TextEditingController _dovePranziController = TextEditingController();
  final TextEditingController _doveCeniController = TextEditingController();
  final TextEditingController _pastoLiberoController = TextEditingController();
  final TextEditingController _colazioneController = TextEditingController();
  final TextEditingController _spuntinoController = TextEditingController();
  final TextEditingController _cosaMangiAPranzoController = TextEditingController();
  final TextEditingController _cosaMangiACenaController = TextEditingController();
  int? _peso;
  int? _altezza;
  String? _malattieCardiacheParenti;
  String? _malattieFamiliari;
  String? _diabeteAsmaPressione;
  final TextEditingController _dettagliProblemiSaluteController = TextEditingController();
  String? _consumiFuoriPasto;
  bool _formSubmitted = false;
  String? _pdfUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final response = await http.get(
      Uri.parse('https://gestionale.fcsocialfitness.it/api/users/getUserData'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
      },
    );

    if (response.statusCode == 200) {
      final userData = json.decode(response.body)['userdata'];
      setState(() {
        _nomeCompletoController.text = userData['nome_completo'] ?? '';
        _telefonoController.text = userData['telefono'] ?? '';
        _emailController.text = userData['email'] ?? '';
        _genere = userData['genere'];
        _dataNascita = DateTime.tryParse(userData['data_nascita'] ?? '');
      });
    } else {
      print('Errore nel recuperare i dati utente: ${response.body}');
    }
  }

  @override
  void dispose() {
    _nomeCompletoController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _sportController.dispose();
    _oreSportSettimanaController.dispose();
    _tipoAlcoolController.dispose();
    _volteAlcoolSettimanaController.dispose();
    _tipoProblemiIntestinaliController.dispose();
    _tipoFarmaciController.dispose();
    _tipoLavoroController.dispose();
    _tipoAllergieController.dispose();
    _tipoIntolleranzeController.dispose();
    _tipoProblemiStomacoController.dispose();
    _dovePranziController.dispose();
    _doveCeniController.dispose();
    _pastoLiberoController.dispose();
    _colazioneController.dispose();
    _spuntinoController.dispose();
    _cosaMangiAPranzoController.dispose();
    _cosaMangiACenaController.dispose();
    _dettagliProblemiSaluteController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    try {
      print("Inizio del processo di invio del form.");
      if (_formKey.currentState!.validate()) {
        print("Validazione del form superata.");
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        bool? formInviato = prefs.getBool('form_nutrizione_inviato');
        if (formInviato != null && formInviato) {
          print("Il form è già stato inviato. Non può essere inviato di nuovo.");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Hai già inviato il questionario nutrizionale.'),
            ),
          );
          return;
        }
        final String? token = prefs.getString('auth_token');
        if (token == null) {
          print("Token non trovato nello SharedPreferences. L'utente potrebbe non essere autenticato.");
          return;
        }
        print("Token recuperato dallo SharedPreferences: $token");
        final String? formattedDataNascita = _dataNascita != null ? DateFormat('dd-MM-yyyy').format(_dataNascita!) : null;
        final Map<String, String> motivoVisitaMapping = {
          'Perdere peso': 'perdere_peso',
          'Cura': 'cura',
          'Post gravidanza': 'post_gravidanza',
          'Altro': 'altro'
        };
        final Map<String, String> consumoAcquaMapping = {
          'Meno di 1 litro': 'meno_di_1_litro',
          'Tra 1 e 2 litri': 'tra_1_e_2_litri',
          'Oltre 3 litri': 'oltre_3_litri'
        };
        print("Peso: $_peso, Altezza: $_altezza");
        final Map<String, dynamic> formData = {
          'nome_completo': _nomeCompletoController.text,
          'telefono': _telefonoController.text,
          'email': _emailController.text,
          'genere': _genere,
          'peso': _peso,
          'altezza': _altezza,
          'data_nascita': formattedDataNascita,
          'motivo_visita': motivoVisitaMapping[_motivoVisita] ?? 'perdere_peso',
          'esami_fuori_range': _esamiFuoriRange == 'si',
          'pratichi_sport': _pratichiSport == 'si',
          'fumi': _fumi == 'si',
          'consumi_alcool': _consumiAlcool == 'si',
          'malattie_cardiache_parenti': _malattieCardiacheParenti == 'si',
          'malattie_familiari': _malattieFamiliari == 'si',
          'diabete_asma_pressione': _diabeteAsmaPressione == 'si',
          'sport': _sportController.text.isNotEmpty ? _sportController.text : '',
          'ore_sport_settimana': int.tryParse(_oreSportSettimanaController.text) ?? 0,
          'tipo_alcool': _tipoAlcoolController.text.isNotEmpty ? _tipoAlcoolController.text : '',
          'volte_alcool_settimana': int.tryParse(_volteAlcoolSettimanaController.text) ?? 0,
          'consumo_acqua': consumoAcquaMapping[_consumoAcqua] ?? 'meno_di_1_litro',
          'problemi_intestinali': _problemiIntestinali == 'si',
          'tipo_problemi_intestinali': _tipoProblemiIntestinaliController.text.isNotEmpty ? _tipoProblemiIntestinaliController.text : '',
          'ciclo_regolare': _cicloRegolare == 'si',
          'assumi_farmaci': _assumiFarmaci == 'si',
          'tipo_farmaci': _tipoFarmaciController.text.isNotEmpty ? _tipoFarmaciController.text : '',
          'lavoro_sedentario': _lavoroSedentario == 'si',
          'tipo_lavoro': _tipoLavoroController.text.isNotEmpty ? _tipoLavoroController.text : '',
          'allergie_alimentari': _allergieAlimentari == 'si',
          'tipo_allergie': _tipoAllergieController.text.isNotEmpty ? _tipoAllergieController.text : '',
          'intolleranze_alimentari': _intolleranzeAlimentari == 'si',
          'tipo_intolleranze': _tipoIntolleranzeController.text.isNotEmpty ? _tipoIntolleranzeController.text : '',
          'problemi_stomaco': _problemiStomaco == 'si',
          'tipo_problemi_stomaco': _tipoProblemiStomacoController.text.isNotEmpty ? _tipoProblemiStomacoController.text : '',
          'dove_pranzi': _dovePranziController.text.isNotEmpty ? _dovePranziController.text : '',
          'dove_ceni': _doveCeniController.text.isNotEmpty ? _doveCeniController.text : '',
          'pasto_libero': _pastoLiberoController.text.isNotEmpty ? _pastoLiberoController.text : '',
          'colazione': _colazioneController.text.isNotEmpty ? _colazioneController.text : '',
          'spuntino': _spuntinoController.text.isNotEmpty ? _spuntinoController.text : '',
          'cosa_mangi_a_pranzo': _cosaMangiAPranzoController.text.isNotEmpty ? _cosaMangiAPranzoController.text : '',
          'cosa_mangi_a_cena': _cosaMangiACenaController.text.isNotEmpty ? _cosaMangiACenaController.text : '',
        };
        print("FormData pronto per l'invio: ${jsonEncode(formData)}");

        final response = await http.post(
          Uri.parse('https://gestionale.fcsocialfitness.it/api/questionari/storeQuestionarioNutrizione'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(formData),
        );

        if (response.statusCode == 201) {
          print("Form inviato con successo.");
          setState(() {
            _formSubmitted = true;
          });
        } else {
          print("Errore nell'invio del form: ${response.statusCode}");
        }
      }
    } catch (e) {
      print("Errore catturato durante l'invio del form: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DietViewModel>.reactive(
        viewModelBuilder: () => DietViewModel(context),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return vm.isBusy
              ? const FitnessLoading()
              : Scaffold(
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).trainingsBackground,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                "Questionario Nutrizione",
                style: FlutterFlowTheme.of(context).title3,
              ),
            ),
            backgroundColor: FlutterFlowTheme.of(context).trainingsBackground,
            body: SafeArea(
                top: true,
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: FlutterFlowTheme.of(context).trainings,
                    ),
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.all(15),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Text(
                                "In questa pagina puoi completare il questionario per il tuo piano alimentare personalizzato. Fornisci tutte le informazioni richieste per aiutare i nostri professionisti ad elaborare un piano alimentare adatto alle tue esigenze",
                                style: FlutterFlowTheme.of(context).bodyText2,
                                textAlign: TextAlign.justify,
                              ),
                            ),
                              TextFormField(
                                controller: _nomeCompletoController,
                                decoration: const InputDecoration(
                                    labelText: 'Nome e Cognome'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Inserisci il tuo nome completo';
                                  }
                                  return null;
                                },
                              ),
                            ElevatedButton(
                              onPressed: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );

                                if (pickedDate != null) {
                                  setState(() {
                                    _dataNascita = pickedDate;
                                  });
                                }
                              },
                              child: Text(_dataNascita == null
                                  ? 'Seleziona la data di nascita'
                                  : 'Data di nascita: ${DateFormat('dd/MM/yyyy').format(_dataNascita!)}'),
                            ),
                              TextFormField(
                                controller: _telefonoController,
                                decoration: const InputDecoration(
                                    labelText: 'Telefono'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Inserisci il tuo numero di telefono';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _emailController,
                                decoration:
                                    const InputDecoration(labelText: 'Email'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Inserisci la tua email';
                                  }
                                  return null;
                                },
                              ),
                              DropdownButtonFormField<String>(
                                value: _genere,
                                decoration:
                                    const InputDecoration(labelText: 'Genere'),
                                items: ['uomo', 'donna'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _genere = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Seleziona il tuo genere';
                                  }
                                  return null;
                                },
                              ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(labelText: 'Altezza (cm)'),
                              onChanged: (newValue) {
                                setState(() {
                                  _altezza = int.tryParse(newValue) ?? 0;
                                });
                                print("Altezza aggiornata: $_altezza");
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Inserisci la tua altezza';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(labelText: 'Peso (kg)'),
                              onChanged: (newValue) {
                                setState(() {
                                  _peso = int.tryParse(newValue) ?? 0;
                                });
                                print("Peso aggiornato: $_peso");
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Inserisci il tuo peso';
                                }
                                return null;
                              },
                            ),
                              TextFormField(
                                controller: _sportController,
                                decoration: const InputDecoration(
                                    labelText: 'Pratichi sport?'),
                                validator: (value) {
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _oreSportSettimanaController,
                                decoration: const InputDecoration(
                                    labelText:
                                        'Quante ore di sport fai a settimana?'),
                                validator: (value) {
                                  return null;
                                },
                              ),
                              DropdownButtonFormField<String>(
                                value: _motivoVisita,
                                decoration: const InputDecoration(
                                    labelText:
                                        'Come mai vuoi richiedere un piano nutrizionale personalizzato?'),
                                items: [
                                  'Perdere peso',
                                  'Cura',
                                  'Post gravidanza',
                                  'Altro'
                                ].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _motivoVisita = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Seleziona il motivo della visita';
                                  }
                                  return null;
                                },
                              ),
                              DropdownButtonFormField<String>(
                                value: _malattieCardiacheParenti,
                                decoration: const InputDecoration(
                                    labelText: 'I tuoi parenti hanno malattie cardiache?'),
                                items: ['si', 'no'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _malattieCardiacheParenti = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Seleziona un\'opzione';
                                  }
                                  return null;
                                },
                              ),
                              DropdownButtonFormField<String>(
                                value: _malattieFamiliari,
                                decoration: const InputDecoration(
                                    labelText: 'Vi è qualche patologia familiare ereditaria?'),
                                items: ['si', 'no'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _malattieFamiliari = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Seleziona un\'opzione';
                                  }
                                  return null;
                                },
                              ),
                              DropdownButtonFormField<String>(
                                value: _diabeteAsmaPressione,
                                decoration: const InputDecoration(
                                    labelText: 'Diabete, Asma, Pressione alta o bassa?'),
                                items: ['si', 'no'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _diabeteAsmaPressione = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Seleziona un\'opzione';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _dettagliProblemiSaluteController,
                                decoration: const InputDecoration(
                                    labelText: 'Fornisci maggiori dettagli sui tuoi problemi di salute'),
                                validator: (value) {
                                  return null;
                                },
                              ),
                              DropdownButtonFormField<String>(
                                value: _consumoAcqua,
                                decoration: const InputDecoration(
                                    labelText: 'Quanta acqua bevi al giorno?'),
                                items: [
                                  'Meno di 1 litro',
                                  'Tra 1 e 2 litri',
                                  'Oltre 3 litri'
                                ].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _consumoAcqua = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Seleziona il tuo consumo di acqua';
                                  }
                                  return null;
                                },
                              ),
                              DropdownButtonFormField<String>(
                                value: _esamiFuoriRange,
                                decoration: const InputDecoration(
                                    labelText: 'Esami Fuori Range?'),
                                items: ['si', 'no'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _esamiFuoriRange = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Seleziona se hai esami fuori range';
                                  }
                                  return null;
                                },
                              ),
                              DropdownButtonFormField<String>(
                                value: _pratichiSport,
                                decoration: const InputDecoration(
                                    labelText: 'Pratichi Sport?'),
                                items: ['si', 'no'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _pratichiSport = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Seleziona se pratichi sport';
                                  }
                                  return null;
                                },
                              ),
                              DropdownButtonFormField<String>(
                                value: _fumi,
                                decoration:
                                    const InputDecoration(labelText: 'Fumi?'),
                                items: ['si', 'no'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _fumi = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Seleziona se fumi';
                                  }
                                  return null;
                                },
                              ),
                              DropdownButtonFormField<String>(
                                value: _consumiAlcool,
                                decoration: const InputDecoration(
                                    labelText: 'Consumi Alcool?'),
                                items: ['si', 'no'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _consumiAlcool = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Seleziona se consumi alcool';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _tipoAlcoolController,
                                decoration: const InputDecoration(
                                    labelText: 'Che tipo di alcolici bevi?'),
                                validator: (value) {
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _volteAlcoolSettimanaController,
                                decoration: const InputDecoration(
                                    labelText:
                                        'Quante volte a settimana consumi alcolici?'),
                                validator: (value) {
                                  return null;
                                },
                              ),
                              DropdownButtonFormField<String>(
                                value: _problemiIntestinali,
                                decoration: const InputDecoration(
                                    labelText: 'Hai problemi instestinali?'),
                                items: ['si', 'no'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _problemiIntestinali = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Seleziona se hai problemi intestinali';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _tipoProblemiIntestinaliController,
                                decoration: const InputDecoration(
                                    labelText:
                                        'Che tipo di problemi intestinali hai?'),
                                validator: (value) {
                                  return null;
                                },
                              ),
                              DropdownButtonFormField<String>(
                                value: _cicloRegolare,
                                decoration: const InputDecoration(
                                    labelText:
                                        'Il tuo ciclo mestruale è regolare?'),
                                items: ['si', 'no'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _cicloRegolare = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Seleziona se hai il ciclo regolare';
                                  }
                                  return null;
                                },
                              ),
                              DropdownButtonFormField<String>(
                                value: _assumiFarmaci,
                                decoration: const InputDecoration(
                                    labelText: 'Assumi Farmaci?'),
                                items: ['si', 'no'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _assumiFarmaci = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Seleziona se assumi farmaci';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _tipoFarmaciController,
                                decoration: const InputDecoration(
                                    labelText: 'Che tipo di farmaci assumi?'),
                                validator: (value) {
                                  return null;
                                },
                              ),
                              DropdownButtonFormField<String>(
                                value: _lavoroSedentario,
                                decoration: const InputDecoration(
                                    labelText: 'Fai un lavoro sedentario?'),
                                items: ['si', 'no'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _lavoroSedentario = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Seleziona se hai un lavoro sedentario';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _tipoLavoroController,
                                decoration: const InputDecoration(
                                    labelText: 'Che tipo di lavoro fai?'),
                                validator: (value) {
                                  return null;
                                },
                              ),
                              DropdownButtonFormField<String>(
                                value: _allergieAlimentari,
                                decoration: const InputDecoration(
                                    labelText: 'Hai allergie alimentari?'),
                                items: ['si', 'no'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _allergieAlimentari = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Seleziona se hai allergie alimentari';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _tipoAllergieController,
                                decoration: const InputDecoration(
                                    labelText:
                                        'Che tipo di allergie alimentari hai?'),
                                validator: (value) {
                                  return null;
                                },
                              ),
                              DropdownButtonFormField<String>(
                                value: _intolleranzeAlimentari,
                                decoration: const InputDecoration(
                                    labelText: "Hai intolleranze alimentari?"),
                                items: ["si", "no"].map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _intolleranzeAlimentari = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return "Seleziona se hai intolleranze alimentari";
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _tipoIntolleranzeController,
                                decoration: const InputDecoration(
                                    labelText:
                                        "Che tipo di intolleranze alimentare hai?"),
                                validator: (value) {
                                  return null;
                                },
                              ),
                              DropdownButtonFormField(
                                value: _problemiStomaco,
                                decoration: const InputDecoration(
                                    labelText: "Hai Problemi di Stomaco?"),
                                items: ["si", "no"].map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _problemiStomaco = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return "Seleziona se hai problemi di stomaco";
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _tipoProblemiStomacoController,
                                decoration: const InputDecoration(
                                    labelText: "Tipo di Problemi di Stomaco"),
                                validator: (value) {
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _dovePranziController,
                                decoration: const InputDecoration(
                                    labelText: "Dove Pranzi?"),
                                validator: (value) {
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _doveCeniController,
                                decoration: const InputDecoration(
                                    labelText: "Dove Ceni?"),
                                validator: (value) {
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _colazioneController,
                                decoration: const InputDecoration(
                                    labelText: "Cosa consumi abitualmente a colazione?"),
                                validator: (value) {
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _spuntinoController,
                                decoration: const InputDecoration(
                                    labelText: "Cosa consumi abitualmente come spuntino?"),
                                validator: (value) {
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _cosaMangiAPranzoController,
                                decoration: const InputDecoration(
                                    labelText: "Cosa Mangi a Pranzo?"),
                                validator: (value) {
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _cosaMangiACenaController,
                                decoration: const InputDecoration(
                                    labelText: "Cosa Mangi a Cena?"),
                                validator: (value) {
                                  return null;
                                },
                              ),
                              DropdownButtonFormField(
                                value: _consumiFuoriPasto,
                                decoration: const InputDecoration(
                                    labelText: "Hai l'abitudine di mangiare fuori pasto?"),
                                items: ["si", "no"].map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _consumiFuoriPasto = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return "Seleziona se consumi fuori pasto";
                                  }
                                  return null;
                                },
                              ),
                            ElevatedButton(
                              onPressed: _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7E57C2),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      30),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: const Text('Invia'),
                            ),
                            ]),
                          ))),
                );
        });
  }
}
