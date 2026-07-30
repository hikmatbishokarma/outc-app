import 'package:flutter/material.dart';

Widget buildNote(String? title, String? value) {
  return (value?.isEmpty ?? true)
      ? const SizedBox()
      : Builder(builder: (context) {
          final theme = Theme.of(context);
          return Card(
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: theme.colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.only(
                    top: 10.0, right: 8.0, bottom: 5.0, left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title ?? "",
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Image.asset(
                            'images/rightarrow.png',
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      value ?? "",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
}
