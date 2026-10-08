# Implementation Plan - Practical Exams & Chapter Redesign

Add practical hand-tracking exams for chapters 5 and 6 (Selamta, Tezeta, Anchihoye), update course progress tracking with exam accuracy thresholds, create the `PracticalExamScreen`, update the router, and redesign chapter headers and reading typography in `ChapterScreen`.

## User Review Required

> [!IMPORTANT]
> Practical tests require hand-tracking and accuracy thresholds ($\ge 70\%$) before chapters 5 and 6 are marked as fully completed.

## Proposed Changes

### 1. Course Data & Progress Service
#### [MODIFY] [curriculum.dart](file:///C:/Users/PAVILION/Desktop/virtual_begena/lib/core/data/curriculum.dart)
- Add `examPassAccuracy` and `examsFor` constants.
- Add `TaskKind.exam` enum value, `Task.exam` constructor, label, and route mapping.
- Update `dailyPlan` for days 13, 17, and 20 to include practical exams.
#### [MODIFY] [course_progress_service.dart](file:///C:/Users/PAVILION/Desktop/virtual_begena/lib/core/services/course_progress_service.dart)
- Update `CourseSnapshot` with `exams` map, `examsPassed` check, and updated `chapterDone` logic.
- Add `saveExam` method.

### 2. Practical Exam Screen
#### [NEW] [practical_exam_screen.dart](file:///C:/Users/PAVILION/Desktop/virtual_begena/lib/features/exam/practical_exam_screen.dart)
- Implement interactive hand-tracking pluck-to-match test with target fingers, error tracking, accuracy calculation, and result dialogs.

### 3. Router
#### [MODIFY] [app_router.dart](file:///C:/Users/PAVILION/Desktop/virtual_begena/lib/routes/app_router.dart)
- Import `PracticalExamScreen` and add the `/exam` route parsing `qenet`.

### 4. Chapter Screen & Redesign
#### [MODIFY] [chapter_screen.dart](file:///C:/Users/PAVILION/Desktop/virtual_begena/lib/features/course/chapter_screen.dart)
- Add `_ExamCard` widget for practical tests in chapter quiz/exam tabs.
- Redesign chapter header with a styled gradient card, badge, and read-time estimate.
- Update `_learn` with formatted paragraph styling (`_para`) supporting verse reference styling.

## Verification Plan

### Automated Tests
- Run `flutter analyze` to verify static typing and imports.

### Manual Verification
- Test navigation to `/exam?qenet=selamta`, complete the pluck test, and verify accuracy tracking and chapter completion.
