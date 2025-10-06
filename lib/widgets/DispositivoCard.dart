import 'package:flutter/material.dart';

class DispositivoCard extends StatelessWidget {
  final int id;
  final String name;
  final String room;
  final bool status;
  final VoidCallback onToggle;
  final VoidCallback onTap;

  const DispositivoCard({
    super.key,
    required this.id,
    required this.name,
    required this.room,
    required this.status,
    required this.onToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const redColor = Color(0xFFB42222);
    const greyText = Color(0xFFA6A6A6);
    const cardColor = Color(0xFFF6F6F6);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Ícone
            Icon(
              Icons.power_outlined,
              size: 28,
              color: status ? redColor : greyText,
            ),
            const SizedBox(width: 14),

            // Nome e descrição
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: greyText,
                    ),
                  ),
                  Text(
                    "${status ? 'Ligado' : 'Desligado'} | $room",
                    style: const TextStyle(
                      color: greyText,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // Toggle switch (estilo limpo, sem borda)
            Switch(
              value: status,
              onChanged: (_) => onToggle(),
              activeColor: Colors.white, // bolinha branca
              activeTrackColor: redColor, // fundo vermelho
              inactiveThumbColor: Colors.white, // bolinha branca quando off
              inactiveTrackColor: const Color(0xFFA6A6A6), // trilha cinza média
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              splashRadius: 0,
            ),
          ],
        ),
      ),
    );
  }
}
