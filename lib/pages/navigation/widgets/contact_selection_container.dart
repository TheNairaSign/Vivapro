import 'package:flutter/material.dart';
import 'package:flutter_contacts/models/contact/contact.dart';
import 'package:vivapro/features/contacts/presentation/widgets/favorite_avatar.dart';
import 'package:vivapro/pages/contact_picker_page.dart';

class ContactSelectionContainer extends StatefulWidget {
  final Contact? initialContact;
  final Function(Contact) onContactSelected;

  const ContactSelectionContainer({
    super.key,
    this.initialContact,
    required this.onContactSelected,
  });

  @override
  State<ContactSelectionContainer> createState() => _ContactSelectionContainerState();
}

class _ContactSelectionContainerState extends State<ContactSelectionContainer> {
  Contact? _selectedContact;

  @override
  void initState() {
    super.initState();
    _selectedContact = widget.initialContact;
  }

  @override
  void didUpdateWidget(ContactSelectionContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialContact != oldWidget.initialContact) {
      _selectedContact = widget.initialContact;
    }
  }

  Future<void> _pickContact() async {
    final contact = await Navigator.push<Contact>(
      context,
      MaterialPageRoute(builder: (context) => const ContactPickerPage()),
    );
    if (contact != null) {
      setState(() => _selectedContact = contact);
      widget.onContactSelected(contact);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: _pickContact,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C3E) : const Color(0xFFF2F4F7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _selectedContact != null
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            if (_selectedContact != null)
              FavoriteAvatar(contact: _selectedContact, radius: 24)
            else
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                radius: 24,
                child: Icon(
                  Icons.person_add,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedContact?.displayName ?? 'Select Contact',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF1A1D1E),
                    ),
                  ),
                  if (_selectedContact != null && _selectedContact!.phones.isNotEmpty)
                    Text(
                      _selectedContact!.phones.first.number,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}