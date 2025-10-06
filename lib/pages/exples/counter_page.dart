import 'package:aim/_classes/herald/app_zoom.dart';
import 'package:aim/_configs/theme_helper.dart';
import 'package:aim/_ext/build_context_ext.dart';
import 'package:aim/design/wrapper/text_wrapper.dart';
import 'package:aim/pages/_interfaces/abstract_page_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  CounterPageState createState() => CounterPageState();
}

class CounterPageState extends AbstractPageState<CounterPage> {
  int _counter = 0;

  @override
  String getTitle() => 'Counter Demo';

  @override
  String getButtonName() => 'Increment';

  @override
  String? getHelperName() => 'counter_help'; // Optional: Reference to help markdown file

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
      }
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget buildButton(BuildContext context, BoxConstraints constraints) {
    return FloatingActionButton.extended(
      heroTag: 'increment_button',
      onPressed: _incrementCounter,
      icon: const Icon(Icons.add),
      label: TextWrapper(getButtonName()),
      tooltip: 'Increment counter',
    );
  }

  @override
  Widget buildContent(BuildContext context, BoxConstraints constraints) {
    final theme = Theme.of(context);
    final width = constraints.maxWidth;

    return Container(
      color: context.colorScheme.surface,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(ThemeHelper.getIndent(2)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Counter display
            Container(
              width: width > 400 ? 300 : width * 0.8,
              padding: EdgeInsets.all(ThemeHelper.getIndent(3)),
              decoration: BoxDecoration(
                color: context.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: context.colorScheme.shadow.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextWrapper(
                    'Counter Value',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  SizedBox(height: ThemeHelper.getIndent()),
                  TextWrapper(
                    '$_counter',
                    style: theme.textTheme.displayLarge?.copyWith(
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 72,
                    ),
                  ),
                  SizedBox(height: ThemeHelper.getIndent(0.5)),
                  TextWrapper(
                    _counter == 1 ? 'time' : 'times',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: ThemeHelper.getIndent(4)),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Decrement button
                ElevatedButton.icon(
                  onPressed: _counter > 0 ? _decrementCounter : null,
                  icon: const Icon(Icons.remove),
                  label: const TextWrapper('Decrease'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: ThemeHelper.getIndent(2),
                      vertical: ThemeHelper.getIndent(),
                    ),
                    backgroundColor: context.colorScheme.errorContainer,
                    foregroundColor: context.colorScheme.onErrorContainer,
                  ),
                ),

                SizedBox(width: ThemeHelper.getIndent(2)),

                // Reset button
                ElevatedButton.icon(
                  onPressed: _counter > 0 ? _resetCounter : null,
                  icon: const Icon(Icons.refresh),
                  label: const TextWrapper('Reset'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: ThemeHelper.getIndent(2),
                      vertical: ThemeHelper.getIndent(),
                    ),
                    backgroundColor: context.colorScheme.secondaryContainer,
                    foregroundColor: context.colorScheme.onSecondaryContainer,
                  ),
                ),
              ],
            ),

            SizedBox(height: ThemeHelper.getIndent(4)),

            // Zoom control section
            Container(
              width: width > 400 ? 300 : width * 0.8,
              padding: EdgeInsets.all(ThemeHelper.getIndent(2)),
              decoration: BoxDecoration(
                color: context.colorScheme.tertiaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: context.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.zoom_in,
                            size: 20,
                            color: context.colorScheme.tertiary,
                          ),
                          SizedBox(width: ThemeHelper.getIndent(0.5)),
                          TextWrapper(
                            'Zoom Level',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: context.colorScheme.onTertiaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      TextWrapper(
                        '${(context.watch<AppZoom>().value * 100).toInt()}%',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: context.colorScheme.tertiary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ThemeHelper.getIndent()),
                  Slider(
                    value: context.watch<AppZoom>().value,
                    min: 0.6,
                    max: 2.0,
                    divisions: 28,
                    label: '${(context.watch<AppZoom>().value * 100).toInt()}%',
                    onChanged: (value) {
                      context.read<AppZoom>().set(value);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWrapper(
                        '60%',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onTertiaryContainer.withValues(alpha: 0.6),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          context.read<AppZoom>().set(1);
                        },
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const TextWrapper('Reset'),
                        style: TextButton.styleFrom(
                          foregroundColor: context.colorScheme.tertiary,
                        ),
                      ),
                      TextWrapper(
                        '200%',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onTertiaryContainer.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: ThemeHelper.getIndent(4)),

            // Info card
            Container(
              width: width > 400 ? 300 : width * 0.8,
              padding: EdgeInsets.all(ThemeHelper.getIndent(2)),
              decoration: BoxDecoration(
                color: context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: context.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: context.colorScheme.primary,
                      ),
                      SizedBox(width: ThemeHelper.getIndent(0.5)),
                      TextWrapper(
                        'Statistics',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: context.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ThemeHelper.getIndent()),
                  TextWrapper(
                    _counter == 0
                        ? 'Start counting by pressing the button below!'
                        : _counter < 10
                            ? 'Keep going, you\'re doing great!'
                            : _counter < 50
                                ? 'Wow! You\'re on a roll!'
                                : 'Amazing! You\'ve reached $_counter!',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                    // textAlign: TextAlign.center, ERR: textAlign is not a property of TextWrapper
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Optional: Override bar actions to add custom actions
  @override
  List<Widget> getBarActions(NavigatorState nav) {
    final baseActions = super.getBarActions(nav);

    // Add a custom reset action to the app bar
    if (_counter > 0) {
      return [
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: 'Reset Counter',
          onPressed: _resetCounter,
          color: Colors.white70,
        ),
        ...baseActions,
      ];
    }

    return baseActions;
  }
}