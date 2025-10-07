// Copyright 2023 The terCAD team. All rights reserved.
// Use of this source code is governed by a CC BY-NC-ND 4.0 license that can be found in the LICENSE file.

import 'package:grinder/grinder.dart';
import './tasks/mock.dart' as m;
import './tasks/test.dart' as t;
import './tasks/coverage.dart' as c;
import './tasks/hook.dart' as h;
import './tasks/release.dart' as r;
import './tasks/localization.dart' as l;
import './tasks/dependency.dart' as d;

void main(List<String> args) => grind(args);

@DefaultTask()
void defaultTask() {
  log('Run `dart run grinder -h` to view the list');
  log('Run `dart run grinder <taskName>` to execute the task');
}

@Task('Generate Mocks')
void mock() => m.mock();

@Task('Fix Mocks by Dart Format')
void fixMock() => m.fixMock();

@Task('Run tests')
@Depends(mock)
void test() => t.test();

@Task('Generate file with all lib/**.dart-files included')
void fullCoverage() => c.fullCoverage();

@Task('Generate Coverage Badge for README.md file')
void coverageBadge() => c.coverageBadge();

@Task('Generate Dependency Graph')
void generateClassGraph() => d.generateClassGraph();

@Task('Create Dependency Graph\n'
    '    To show the diff on pull-request use: --diff --from=hash --to=hash\n'
    '    Sample: --diff --from=\${{ github.event.pull_request.base.sha }}'
    ' --to=\${{ github.event.pull_request.head.sha }}')
@Depends(generateClassGraph)
void createClassGraph() => d.createClassGraph();

@Task('Create Dependency Graph from existing .dot-file\n    Required: --file="{path}"')
void createClassGraphFromDot() => d.createClassGraphFromDot();

@Task('Install Git Hooks')
void installGitHooks() => h.installGitHooks();

@Task('Generate Release Notes')
void releaseNotes() => r.releaseNotes();

@Task('Patch Config Files')
void pubspecUpdate() => r.pubspecUpdate();

@Task('Update Translations by sorting values alphabetically')
void sortTranslations() => l.sortTranslations();

@Task('Export Translations\n    To limit the scope use: --filter={language}\n    Sample: --filter="en|be"')
void exportTranslations() => l.exportTranslations();

@Task('Import Translations\n    Required: --file="{path}"')
void importTranslations() => l.importTranslations();
