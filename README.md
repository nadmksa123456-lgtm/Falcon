# TRust Menu

مكتبة واجهة Luau رسمية لسكربتاتك، مصممة للعمل من GitHub Raw في بيئات Executor التي توفر واجهات HTTP والملفات والأصول المخصصة، ومنها Volt والبيئات المتوافقة مع sUNC مثل Xeno.

التصميم الثاني مستقل: خلفية داكنة ثابتة بدرجات `#0F0D12` و`#16131A`، بطاقات بلون `#1E1A23`، وشريطان فاصلان لونهما الافتراضي `#4D1B34`، وشعار النسر الأصلي أعلى اليسار دون اسم تحته. لون المنيو الافتراضي `#FF057E`، ويغيّر عناصر الـAccent مثل الشعار والأيقونات وخطوط البطاقات والسلايدر والـToggle والشريطين، بينما تبقى الخلفية والبطاقات بألوانها الثابتة.

## الملفات

- `source.lua`: محرك الواجهة فقط؛ لا يفتح منيو تلقائيًا.
- `icons.lua`: سجل الصور `0.png` إلى `6.png`، وتحميلها وتخزينها محليًا للـExecutor.
- `loader.lua`: الملف الذي يُستدعى من GitHub Raw؛ يحمل المحرك وكل الصور ويعيد `Library` جاهزة.
- `template.lua`: أساس فارغ فيه الشعار والفئات والتبويبات والأقسام، جاهز لإضافة مميزات أي سكربت.
- `example.lua`: مثال محلي لعناصر الواجهة.
- `assets/`: الشعار وجميع أيقونات المنيو بصيغة PNG شفافة وقابلة للتلوين.

## تجهيز GitHub Raw

المستودع المستقل هو `nadmksa123456-lgtm/TRust-hub` على فرع `main`:

1. ارفع جميع الملفات مع مجلد `assets` من دون تغيير بنيته.
2. استخدم رابط Raw الخاص بـ`loader.lua` داخل سكربتاتك.

```lua
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/nadmksa123456-lgtm/TRust-hub/refs/heads/main/loader.lua"
))()

local Window = Library:CreateWindow({
    Name = "My Script",
    ThemeColor = Color3.fromRGB(255, 5, 126),
    ToggleKey = Enum.KeyCode.Insert,
})

local Main = Window:AddCategory({
    Name = "Main",
    Icon = Library:GetIcon(1),
})

local General = Main:AddTab({Name = "General"})
local Section = General:AddSection({Name = "Settings", Column = 1})

Section:AddToggle({
    Text = "Enabled",
    Flag = "enabled",
    Default = false,
})

Section:AddSlider({
    Text = "Value",
    Flag = "value",
    Min = 0,
    Max = 100,
    Default = 50,
})
```

## الأساس الجاهز

`template.lua` ينشئ البنية فقط، من دون مميزات لعب:

- Main
- Targeting
- Visuals
- Players
- Settings

الفئات الأربع الأولى فارغة عمدًا وقابلة لإضافة التبويبات والبطاقات والمميزات. قسم `Settings` وحده يحتفظ بتبويب `Settings` وبطاقة `Menu Settings` التي تحتوي `Menu Color` و`Menu Opacity`.

بعد تحميل القالب أنشئ تبويبًا علويًا وبطاقة داخل الفئة المطلوبة، ثم أضف مميزاتك:

```lua
local Menu = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/nadmksa123456-lgtm/TRust-hub/refs/heads/main/template.lua"
))()

local General = Menu.Categories.Main:AddTab({Name = "General"})
local MainSection = General:AddSection({Name = "Main", Column = 1})

MainSection:AddToggle({
    Text = "My Feature",
    Flag = "my_feature",
})
```

## تحميل جميع الصور

عند تشغيل `loader.lua` يستدعي `Icons:PrepareAll()` تلقائيًا ويحاول تجهيز جميع الصور من `0.png` إلى `6.png`.

تسلسل التحميل:

1. استخدام الصورة الموجودة سابقًا في Workspace الخاص بالـExecutor.
2. إذا لم تكن موجودة، تنزيلها من GitHub Raw.
3. تخزينها داخل `TRust-Menu/assets`.
4. تحويلها إلى رابط قابل للاستخدام بواسطة `getcustomasset` أو `getsynasset`.
5. الاحتفاظ بها في Cache حتى لا يعاد تنزيلها مع كل سكربت.

يمكنك فحص حالة الصور برمجيًا:

```lua
local ready, missing = Library:PrepareAssets()
print("Missing images:", table.concat(missing, ", "))

local status = Library:GetAssetStatus()
print(status[0].Ready, status[0].Path, status[0].Error)
```

## سجل الصور

| الرقم | الاستخدام |
|---:|---|
| 0 | Eagle Logo |
| 1 | Main / Cube |
| 2 | Targeting / Scope |
| 3 | Visuals / View |
| 4 | Players / User |
| 5 | Settings |
| 6 | Pick / Extra |

## متطلبات Executor

الحد الأدنى لتشغيل المكتبة من Raw:

- `loadstring`
- `game:HttpGet` أو `request`
- `gethui` أو الوصول إلى `PlayerGui`

ولتحميل صور GitHub تلقائيًا:

- `writefile`
- `isfile` اختياري لكنه مفضل
- `makefolder` اختياري في البيئات التي تنشئ المجلدات تلقائيًا
- `getcustomasset` أو `getsynasset`

يستخدم المنيو عائلة `Roboto` المدمجة: عناوين الأقسام أكبر وبوزن Bold، بينما
تظهر أسماء المميزات والقيم بوزن Regular خفيف وواضح.

مقياس الخط الافتراضي هو `1.2`. يمكن تغييره قبل تشغيل `template.lua`:

```lua
getgenv().TRUST_MENU_FONT_SCALE = 1.4
```

يمكن التحكم في شفافية النافذة وشدة التوهج من `20` إلى `100`:

```lua
Window:SetOpacity(75, true)
print(Window:GetOpacity())
```

إذا تعذر تحميل صورة، تبقى الواجهة عاملة وتستخدم رمزًا نصيًا للفئة بدل أن يتوقف السكربت بالكامل.
