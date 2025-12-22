import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/contacts/repositories/favorite_repository.dart';
import 'package:vivapro/core/theme/global_colors.dart';

class ContactDetailsPage extends ConsumerStatefulWidget {
  final Contact contact;
  const ContactDetailsPage(this.contact, {super.key});

  @override
  ConsumerState<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends ConsumerState<ContactDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(widget.contact.displayName, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),),
        actions: [
          _buildFavoriteAction(),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildDetailTile(
            Icons.person,
            'Name',
            '${widget.contact.name.first} ${widget.contact.name.last}',
          ),
          if (widget.contact.phones.isNotEmpty)
            ...widget.contact.phones.map(
              (p) => _buildDetailTile(Icons.phone, 'Phone', p.number),
            ),
          if (widget.contact.emails.isNotEmpty)
            ...widget.contact.emails.map(
              (e) => _buildDetailTile(Icons.email, 'Email', e.address),
            ),
        ],
      ),
    );
  }

  Widget _buildFavoriteAction() {
    return StreamBuilder<bool>(
      stream: ref.read(favoritesRepository).watchIsFavorite(widget.contact.id),
      builder: (context, snapshot) {
        final isFavorite = snapshot.data ?? widget.contact.isStarred;
        return IconButton(
          icon: Icon(
            isFavorite ? Icons.star : Icons.star_border,
            color: isFavorite ? Colors.yellow : Colors.white,
          ),
          onPressed: () => _toggleFavorite(isFavorite),
        );
      },
    );
  }

  Future<void> _toggleFavorite(bool isFavorite) async {
    final repo = ref.read(favoritesRepository);
    await repo.toggleFavorite(isFavorite, widget.contact);
  }

  Widget _buildDetailTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: GlobalColors.freshPink),
      title: Text(value),
      subtitle: Text(label),
      contentPadding: EdgeInsets.zero,
    );
  }
}

