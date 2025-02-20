import 'package:fc_social_fitness/utils/flutter_flow_theme.util.dart';
import 'package:fc_social_fitness/views/training_form_submitted.page.dart';
import 'package:fc_social_fitness/views/widgets/fitness_loading.widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import '../utils/flutter_flow.util.dart';
import '../viewmodels/personal_training_survey.viewmodel.dart';

class PersonalTrainingPage extends StatefulWidget {
  @override
  _PersonalTrainingPageState createState() => _PersonalTrainingPageState();
}

class _PersonalTrainingPageState extends State<PersonalTrainingPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeCompletoController = TextEditingController();
  final TextEditingController _professioneController = TextEditingController();
  DateTime? _dataNascita;
  String? _genere;
  int? _eta;
  int? _altezza;
  int? _peso;
  String? _livelloAttivitaLavoro;
  String? _programmaLavoro;
  String? _stressProblemiMotivazionali;
  String? _malattieCardiacheParenti;
  String? _malattieFamiliari;
  String? _problemiSalute;
  final TextEditingController _dettagliProblemiSaluteController =
      TextEditingController();
  String? _fumatoreSigarette;
  String? _dietaAttuale;
  int? _disponibilitaCambiamento;
  String? _obiettivi;
  final TextEditingController _obiettivoAllenamentoController =
      TextEditingController();
  final TextEditingController _motivazioneController = TextEditingController();
  String? _timelineObiettivo;
  String? _allenamentoRegolare;
  String? _allenamentoPersonalTrainer;
  final TextEditingController _genereAllenamentoController =
      TextEditingController();
  String? _orarioAllenamentoPreferito;
  int? _frequenzaAllenamentiSettimanali;
  final TextEditingController _attivitaFisicheController =
      TextEditingController();
  final TextEditingController _programmaLavoroController =
      TextEditingController();
  final TextEditingController _problemiSaluteDiagnosticatiController =
      TextEditingController();
  final TextEditingController _assunzioneFarmaciController =
      TextEditingController();
  final TextEditingController _terapieAggiuntiveController =
      TextEditingController();
  final TextEditingController _lesioniController = TextEditingController();
  bool _formSubmitted = false;

  @override
  void dispose() {
    _nomeCompletoController.dispose();
    _professioneController.dispose();
    _dettagliProblemiSaluteController.dispose();
    _obiettivoAllenamentoController.dispose();
    _motivazioneController.dispose();
    _genereAllenamentoController.dispose();
    _attivitaFisicheController.dispose();
    _problemiSaluteDiagnosticatiController.dispose();
    _assunzioneFarmaciController.dispose();
    _terapieAggiuntiveController.dispose();
    _lesioniController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    try {
      print("Inizio del processo di invio del form.");
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? formInviato = prefs.getBool('form_inviato');
      if (formInviato != null && formInviato) {
        print("Il form è già stato inviato. Non può essere inviato di nuovo.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hai già inviato il questionario.'),
          ),
        );
        return;
      }

      if (_formKey.currentState!.validate()) {
        print("Validazione del form superata.");

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? token = prefs.getString('auth_token');

        if (token == null) {
          print("Token non trovato nello SharedPreferences. L'utente potrebbe non essere autenticato.");
          return;
        }

        print("Token recuperato dallo SharedPreferences: $token");

        final String? formattedDataNascita = _dataNascita != null ? DateFormat('dd-MM-yyyy').format(_dataNascita!) : null;

        final Map<String, String> livelloAttivitaMapping = {
          'Nessuno': 'nessuno',
          'Moderato': 'moderato',
          'Alto': 'alto'
        };

        final Map<String, String> siNoMapping = {
          'Si': 'si',
          'No': 'no',
        };

        final Map<String, String> dietaAttualeMapping = {
          'Pochi grassi': 'poco_grasso',
          'Pochi carboidrati': 'pochi_carboidrati',
          'Elevato apporto proteico': 'alto_proteine',
          'Vegetariana/Vegana': 'vegetariano_vegano',
          'Nessuna dieta': 'nessuna_dieta'
        };

        final Map<String, String> obiettiviMapping = {
          'Migliorare la mia salute fisica': 'salute_migliorata',
          'Migliorare la mia resistenza': 'resistenza_migliorata',
          'Essere più forte': 'maggiore_forza',
          'Aumentare la massa muscolare': 'massa_muscolare',
          'Perdere peso': 'perdita_grasso'
        };

        final Map<String, String> timelineObiettivoMapping = {
          '8 Settimane': '8_settimane',
          '16 Settimane': '16_settimane',
          '24 Settimane': '24_settimane',
          '32 Settimane': '32_settimane',
          '40 Settimane': '40_settimane',
        };

        final Map<String, dynamic> formData = {
          'nome_completo': _nomeCompletoController.text,
          'genere': _genere,
          'data_nascita': formattedDataNascita,
          'eta': _eta,
          'altezza': _altezza,
          'peso': _peso,
          'professione': _professioneController.text,
          'livello_attivita_lavoro': livelloAttivitaMapping[_livelloAttivitaLavoro],
          'programma_lavoro': _programmaLavoro,
          'stress_problemi_motivazionali': siNoMapping[_stressProblemiMotivazionali],
          'malattie_cardiache_parenti': siNoMapping[_malattieCardiacheParenti],
          'malattie_familiari': siNoMapping[_malattieFamiliari],
          'problemi_salute': siNoMapping[_problemiSalute],
          'dettagli_problemi_salute': _dettagliProblemiSaluteController.text,
          'fumatore_sigarette': siNoMapping[_fumatoreSigarette],
          'dieta_attuale': dietaAttualeMapping[_dietaAttuale],
          'disponibilita_cambiamento': _disponibilitaCambiamento,
          'obiettivi': obiettiviMapping[_obiettivi],
          'obiettivo_allenamento': _obiettivoAllenamentoController.text,
          'motivazione': _motivazioneController.text,
          'timeline_obiettivo': timelineObiettivoMapping[_timelineObiettivo],
          'allenamento_regolare': siNoMapping[_allenamentoRegolare],
          'allenamento_personal_trainer': siNoMapping[_allenamentoPersonalTrainer],
          'genere_allenamento': _genereAllenamentoController.text,
          'orario_allenamento_preferito': _orarioAllenamentoPreferito?.toLowerCase(),
          'frequenza_allenamenti_settimanali': _frequenzaAllenamentiSettimanali,
          'attivita_fisiche': _attivitaFisicheController.text,
          'problemi_salute_diagnosticati': _problemiSaluteDiagnosticatiController.text,
          'assunzione_farmaci': _assunzioneFarmaciController.text,
          'terapie_aggiuntive': _terapieAggiuntiveController.text,
          'lesioni': _lesioniController.text,
        };

        print("FormData pronto per l'invio: ${jsonEncode(formData)}");

        final response = await http.post(
          Uri.parse('https://gestionale.fcsocialfitness.it/api/questionari/storeQuestionarioPersonalTraining'),
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
    return ViewModelBuilder<PersonalTrainingViewModel>.reactive(
        viewModelBuilder: () => PersonalTrainingViewModel(context),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return vm.isBusy
              ? const FitnessLoading()
              : Scaffold(
                  appBar: AppBar(
                    backgroundColor:
                        FlutterFlowTheme.of(context).trainingsBackground,
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
                      "Questionario Personal Training",
                      style: FlutterFlowTheme.of(context).title3,
                    ),
                  ),
                  backgroundColor:
                      FlutterFlowTheme.of(context).trainingsBackground,
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
                            child: ListView(children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Text(
                                  "In questa pagina puoi completare il questionario per il Personal Training. Fornisci tutte le informazioni richieste per aiutare i nostri professionisti a creare un piano di allenamento personalizzato per te.",
                                  style: FlutterFlowTheme.of(context).bodyText2,
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              TextFormField(
                                controller: _nomeCompletoController,
                                decoration: const InputDecoration(
                                    labelText: 'Nome Completo'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Inserisci il tuo nome completo';
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
                                    : 'Data di nascita: ${_dataNascita?.toLocal()}'),
                              ),
                              // Età
                              TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(labelText: 'Età'),
                                onChanged: (newValue) {
                                  setState(() {
                                    _eta = int.tryParse(newValue) ?? 0;
                                  });
                                  print("Età aggiornata: $_eta");
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Inserisci la tua età';
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
                                controller: _professioneController,
                                decoration: const InputDecoration(
                                    labelText: 'Qual è la tua professione?'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Inserisci la tua professione';
                                  }
                                  return null;
                                },
                              ),
                              DropdownButtonFormField<String>(
                                value: _livelloAttivitaLavoro,
                                decoration: const InputDecoration(
                                    labelText:
                                        'Livello di attività durante il lavoro'),
                                items: ['Nessuno', 'Moderato', 'Alto']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _livelloAttivitaLavoro = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Seleziona un livello di attività';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _programmaLavoroController,
                                decoration: const InputDecoration(
                                    labelText: 'Programma di lavoro'),
                                validator: (value) {
                                  return null;
                                },
                              ),
                              DropdownButtonFormField<String>(
                                value: _stressProblemiMotivazionali,
                                decoration: const InputDecoration(
                                    labelText:
                                        'Stress o problemi motivazionali?'),
                                items: ['Si', 'No'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _stressProblemiMotivazionali = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Seleziona se hai problemi di stress';
                                  }
                                  return null;
                                },
                              ),
                              DropdownButtonFormField<String>(
                                value: _malattieCardiacheParenti,
                                decoration: const InputDecoration(
                                    labelText:
                                        'Malattie cardiache nei parenti?'),
                                items: ['Si', 'No'].map((String value) {
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
                                    labelText: 'Malattie familiari?'),
                                items: ['Si', 'No'].map((String value) {
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
                                value: _problemiSalute,
                                decoration: const InputDecoration(
                                    labelText:
                                        'Diabete, asma, pressione alta o bassa?'),
                                items: ['Si', 'No'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _problemiSalute = newValue;
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
                                    labelText: 'Dettagli problemi di salute'),
                                validator: (value) {
                                  return null;
                                },
                              ),
                              DropdownButtonFormField<String>(
                                value: _fumatoreSigarette,
                                decoration: const InputDecoration(
                                    labelText: 'Sei un fumatore?'),
                                items: ['Si', 'No'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _fumatoreSigarette = newValue;
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
                                value: _dietaAttuale,
                                decoration: const InputDecoration(
                                    labelText:
                                        'Che tipo di dieta alimentare segui al momento?'),
                                items: [
                                  'Pochi grassi',
                                  'Pochi carboidrati',
                                  'Elevato apporto proteico',
                                  'Vegetariana/Vegana',
                                  'Nessuna dieta'
                                ].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _dietaAttuale = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Seleziona un tipo di dieta';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Disponibilità al cambiamento (1-10)',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Inserisci la tua disponibilità al cambiamento';
                                  }
                                  final parsedValue = int.tryParse(value);
                                  if (parsedValue == null || parsedValue < 1 || parsedValue > 10) {
                                    return 'Inserisci un valore compreso tra 1 e 10';
                                  }
                                  return null;
                                },
                                onChanged: (newValue) {
                                  setState(() {
                                    _disponibilitaCambiamento = int.tryParse(newValue) ?? 0;
                                  });
                                  print("Disponibilità al cambiamento aggiornata: $_disponibilitaCambiamento");
                                },
                              ),
                              DropdownButtonFormField(
                                value: _obiettivi,
                                decoration: const InputDecoration(
                                    labelText: 'Qual è il tuo obiettivo'),
                                items: [
                                  'Migliorare la mia salute fisica',
                                  'Migliorare la mia resistenza',
                                  'Essere più forte',
                                  'Aumentare la massa muscolare',
                                  'Perdere peso'
                                ].map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _obiettivi = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Seleziona il tuo obiettivo';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _obiettivoAllenamentoController,
                                decoration: const InputDecoration(
                                    labelText:
                                        'Obiettivo durante l’allenamento'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Inserisci un obiettivo per il tuo allenamento';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _motivazioneController,
                                decoration: const InputDecoration(
                                    labelText: 'Motivazione'),
                                validator: (value) {
                                  return null;
                                },
                              ),
                              DropdownButtonFormField(
                                value: _timelineObiettivo,
                                decoration: const InputDecoration(
                                    labelText:
                                        'In quanto tempo vuoi raggiungere il tuo obiettivo?'),
                                items: [
                                  '8 Settimane',
                                  '16 Settimane',
                                  '24 Settimane',
                                  '32 Settimane',
                                  '40 Settimane'
                                ].map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _timelineObiettivo = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Seleziona la tua timeline';
                                  }
                                  return null;
                                },
                              ),
                              DropdownButtonFormField(
                                value: _allenamentoRegolare,
                                decoration: const InputDecoration(
                                    labelText: 'Ti alleni con regolarità?'),
                                items: ['Si', 'No'].map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _allenamentoRegolare = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Seleziona un\'opzione';
                                  }
                                  return null;
                                },
                              ),
                              DropdownButtonFormField(
                                value: _allenamentoPersonalTrainer,
                                decoration: const InputDecoration(
                                    labelText:
                                        'Ti sei mai allenato con un personal trainer?'),
                                items: ['Si', 'No'].map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _allenamentoPersonalTrainer = newValue;
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
                                controller: _genereAllenamentoController,
                                decoration: const InputDecoration(
                                    labelText:
                                        'Che tipo di allenamento svolegevi?'),
                                validator: (value) {
                                  return null;
                                },
                              ),
                              DropdownButtonFormField(
                                value: _orarioAllenamentoPreferito,
                                decoration: const InputDecoration(
                                    labelText:
                                        'Che parte della giornata preferisci per allenarti?'),
                                items: [
                                  'Mattina',
                                  'Mezzogiorno',
                                  'Pomeriggio',
                                  'Sera'
                                ].map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _orarioAllenamentoPreferito = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Seleziona l\'orario che preferisci';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(labelText: 'Quante volte a settimana ti alleni?'),
                                onChanged: (newValue) {
                                  setState(() {
                                    _frequenzaAllenamentiSettimanali = int.tryParse(newValue) ?? 0;
                                  });
                                  print("Frequenza Allenamenti Settimanali aggiornata: $_frequenzaAllenamentiSettimanali");
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Inserisci quante volte a settimana ti alleni';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _attivitaFisicheController,
                                decoration: const InputDecoration(
                                    labelText:
                                        'Quali attività fisiche hai praticato fino ad oggi?'),
                                validator: (value) {
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller:
                                    _problemiSaluteDiagnosticatiController,
                                decoration: const InputDecoration(
                                    labelText:
                                        'Hai dei problemi di salute diagnosticati?'),
                                validator: (value) {
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _assunzioneFarmaciController,
                                decoration: const InputDecoration(
                                    labelText: 'Assumi farmaci?'),
                                validator: (value) {
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _terapieAggiuntiveController,
                                decoration: const InputDecoration(
                                    labelText: 'Terapie aggiuntive'),
                                validator: (value) {
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _lesioniController,
                                decoration: const InputDecoration(
                                    labelText: 'Hai avuto delle lesioni?'),
                                validator: (value) {
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
                                    fontSize: 18, // Dimensione del testo
                                    fontWeight: FontWeight.bold, // Grassetto
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
