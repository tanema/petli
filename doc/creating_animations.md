Creating a new animation
------------------------

This project uses a custom text animation atlases as a way to create animations
out of character in a maintainable and expandable way. However since this is
very custom it my be hard to work with at first.

### File Format
The txt format alternates between YAML and animation frames. The parser will
parse the first YAML block and use it as defaults for the rest so that attributes
do not need to be repeated such as `width`, `height`. The following are all of
the attributes that you can set.

#### YAML configs
|Attribute | Required | Default |Description |
|----------|----------|---------|------------|
| `width`  | true     | *n/a*   | width in text characters of each frame.
| `height` | true     | *n/a*   | height in text rows of each frame.
| `name`   | true     |`default`| Name of the animation that can be referred to by `atlas[:name]`. If there is only one animation and no name has been given it will default to `default`. All names must be unique.
| `loop`   | false    | `false` | If `true` the animation will reset at the end.
|`loop_for`| false    | `-1`    | Limited looping. This will allow the animation to loop a limited amount of times.
| `speed`  | false    | `2`     | ms per frame. 2 meaning each frame will be shown for 2ms.

#### Text Frames
An example animation
```
width: 5
height: 2
---
ı ı ı|ϟ ϟ ϟ |
༼ᵔ◡ᵔ༽|༼ಠ益ಠ༽|
```
You can see that the animation has 2 rows, and 5 columns between the separator
`|`. This is the specified frame and you can make animations in there. The
separator actually does not matter, the parser just skips it so you can use another
character if you want (please don't). Lastly, I recommend putting separators right
at the end of your animation as well as this will prevent your editor from trimming
whitespace in your last frame.

### Testing your animation
This project has a tool to test your animation. 'bin/anim' will load your animation
and run it.

`anim [filepath] [animation_name]`

**Example**
```bash
./bin/anim ./data/baby.txtanim celebrate
```
