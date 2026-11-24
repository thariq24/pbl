
import 'dart:async';
import 'package:flutter/material.dart';

import '../../providers/audio_player_provider.dart';

class PengaturanAudioScreen extends StatefulWidget {
  const PengaturanAudioScreen({super.key});

  @override
  State<PengaturanAudioScreen> createState() =>
      _PengaturanAudioScreenState();
}

class _PengaturanAudioScreenState extends State<PengaturanAudioScreen> {
  static const Color navy = Color(0xFF20345B);
  static const Color background = Color(0xFFF5F7FC);
  static const Color accent = Color(0xFFD9E1F1);

  final AudioPlayerProvider _audioProvider = AudioPlayerProvider();

  double _kecepatan = 1.0;
  int? _sleepTimer;
  bool _timerAktif = false;
  bool _hentikanDiAkhirBab = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _kecepatan = _audioProvider.speed;
  }

  void _ubahKecepatan(double value) {
    setState(() {
      _kecepatan = value;
    });

    unawaited(_audioProvider.setSpeed(value));
  }

  void _ubahInterval(int detik) {
    _audioProvider.setSkipInterval(detik);
    setState(() {});
  }

  void _aturSleepTimer(int? menit) {
    _timer?.cancel();

    setState(() {
      _sleepTimer = menit;
      _timerAktif = menit != null;
    });

    if (menit != null) {
      _timer = Timer(Duration(minutes: menit), () {
        if (!mounted) return;

        setState(() {
          _timerAktif = false;
          _sleepTimer = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Waktu tidur selesai. Penghentian audio '
              'belum dihubungkan.',
            ),
          ),
        );
      });
    }
  }

  void _resetPengaturan() {
    _timer?.cancel();

    setState(() {
      _kecepatan = 1.0;
      _sleepTimer = null;
      _timerAktif = false;
      _hentikanDiAkhirBab = false;
    });

    unawaited(_audioProvider.setSpeed(1.0));
    _audioProvider.setSkipInterval(15);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pengaturan dikembalikan ke default.'),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: accent,
        foregroundColor: navy,
        elevation: 0,
        title: const Text(
          'Pengaturan Audio',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Reset pengaturan',
            onPressed: _resetPengaturan,
            icon: const Icon(Icons.restart_alt),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: accent,
                  child: Icon(Icons.headphones, color: navy, size: 30),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pengalaman Mendengarkan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: navy,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Sesuaikan pemutaran audio sesuai kebutuhanmu.',
                        style: TextStyle(
                          color: Colors.black54,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _sectionTitle('Kecepatan Pemutaran'),
          const SizedBox(height: 10),
          _settingCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Atur kecepatan narasi',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    '${_kecepatan.toStringAsFixed(2).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '')}x',
                    style: const TextStyle(
                      color: navy,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Slider(
                  value: _kecepatan,
                  min: 0.5,
                  max: 2.0,
                  divisions: 15,
                  activeColor: navy,
                  label: '${_kecepatan.toStringAsFixed(2)}x',
                  onChanged: _ubahKecepatan,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('0,5x', style: TextStyle(color: Colors.black54)),
                    Text('1,0x', style: TextStyle(color: Colors.black54)),
                    Text('2,0x', style: TextStyle(color: Colors.black54)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Perubahan kecepatan langsung diterapkan '
                  'pada pemutaran audio.',
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _sectionTitle('Interval Lewati Audio'),
          const SizedBox(height: 10),
          _settingCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Durasi maju atau mundur',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Pilih durasi lompatan saat mendengarkan.',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [5, 10, 15, 30].map((detik) {
                    final selected =
                        _audioProvider.skipInterval == detik;

                    return ChoiceChip(
                      label: Text('$detik detik'),
                      selected: selected,
                      selectedColor: accent,
                      onSelected: (_) => _ubahInterval(detik),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                Text(
                  'Interval aktif: ${_audioProvider.skipInterval} detik',
                  style: const TextStyle(
                    color: navy,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Pengaturan ini akan digunakan oleh tombol '
                  'mundur dan maju pada pemutar audio.',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _sectionTitle('Pengatur Waktu Tidur'),
          const SizedBox(height: 10),
          _settingCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hentikan pemutaran setelah',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int?>(
                  initialValue: _sleepTimer,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem<int?>(
                      value: null,
                      child: Text('Nonaktif'),
                    ),
                    DropdownMenuItem<int?>(value: 5, child: Text('5 menit')),
                    DropdownMenuItem<int?>(value: 10, child: Text('10 menit')),
                    DropdownMenuItem<int?>(value: 15, child: Text('15 menit')),
                    DropdownMenuItem<int?>(value: 30, child: Text('30 menit')),
                    DropdownMenuItem<int?>(value: 60, child: Text('60 menit')),
                  ],
                  onChanged: _aturSleepTimer,
                ),
                if (_timerAktif) ...[
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Icon(Icons.timer, color: navy),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Timer aktif. Penghitung waktu akan berjalan '
                          'selama halaman ini terbuka.',
                          style: TextStyle(color: navy),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () => _aturSleepTimer(null),
                    child: const Text('Batalkan timer'),
                  ),
                ],
                const Divider(height: 28),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeTrackColor: navy,
                  title: const Text(
                    'Berhenti di akhir bab',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Direncanakan untuk menghentikan audio '
                    'ketika bab selesai.',
                  ),
                  value: _hentikanDiAkhirBab,
                  onChanged: (value) {
                    setState(() => _hentikanDiAkhirBab = value);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: navy,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Pengaturan kecepatan dan interval '
                      'telah diterapkan.',
                    ),
                  ),
                );
              },
              child: const Text(
                'Selesai',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: navy,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _settingCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
