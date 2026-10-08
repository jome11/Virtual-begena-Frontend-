# Walkthrough - Practical Exams & Chapter Redesign

Successfully implemented interactive practical hand-tracking exams for chapters 5 and 6, integrated exam accuracy thresholds into course progress tracking, created `PracticalExamScreen`, updated routing, and redesigned chapter headers and typography.

## Changes

### 1. Course Data & Progress Service
#### [curriculum.dart](file:///C:/Users/PAVILION/Desktop/virtual_begena/lib/core/data/curriculum.dart)
- Added `examPassAccuracy` (70%) and `examsFor` map.
- Added `TaskKind.exam`, task constructor, label, route mapping, and updated days 13, 17, and 20 in `dailyPlan`.
#### [course_progress_service.dart](file:///C:/Users/PAVILION/Desktop/virtual_begena/lib/core/services/course_progress_service.dart)
- Updated `CourseSnapshot` with `exams` map, `examsPassed` validation, and updated `chapterDone` logic requiring both quiz, assignment, and practical exams.
- Added `saveExam` persistence method.

### 2. Practical Exam Screen
#### [practical_exam_screen.dart](file:///C:/Users/PAVILION/Desktop/virtual_begena/lib/features/exam/practical_exam_screen.dart)
- Created interactive hand-tracking test screen prompting users to pluck 10 notes with specified target fingers, tracking accuracy and mistakes ($\le 4$), and saving passing scores ($\ge 70\%$).

### 3. Router & Chapter Screen
#### [app_router.dart](file:///C:/Users/PAVILION/Desktop/virtual_begena/lib/routes/app_router.dart)
- Added `/exam` route mapping to `PracticalExamScreen`.
#### [chapter_screen.dart](file:///C:/Users/PAVILION/Desktop/virtual_begena/lib/features/course/chapter_screen.dart)
- Redesigned chapter header with a gradient card, chapter number watermark, icon, and dynamic read-time estimate.
- Updated `_learn` reading typography with formatted paragraph rendering (`_para`) featuring verse reference styling.
- Added `_ExamCard` to chapter quiz/exam tabs for chapters 5 and 6.

> [!NOTE]
> Static analysis (`flutter analyze`) verified successfully with zero errors.
