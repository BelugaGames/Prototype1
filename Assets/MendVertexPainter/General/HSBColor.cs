/**
 * License: CC BY-SA 3.0
 * 
 * Author: Jonathan Czeck (aarku)
 * Source: http://wiki.unity3d.com/index.php/HSBColor
 * 
 * Author: Lee Hailey
 * Changes: Added hsb +/- operators. Modified functions to allow conversion from Color. 
 *          Added defaults to channel constructor. Removed redundant constructor. Changed 
 *          ToString() output to be consitent with UnityEngine.Color 
 **/

using UnityEngine;
using System;

namespace Util {
    [System.Serializable]
    public struct HSBColor {
        public float h;
        public float s;
        public float b;
        public float a;

        public HSBColor(float h = 0f, float s = 0f, float b = 0f, float a = 1f) {
            this.h = h;
            this.s = s;
            this.b = b;
            this.a = a;
        }

        public HSBColor(Color col) {
            h = 0f;
            s = 0f;
            b = 0f;
            a = 0f;
            FromColor_(col);
        }

        public static HSBColor FromColor(Color color) {
           HSBColor ret = new HSBColor(color);
           return ret;
        }

        // todo: must overload; wtf, static signatures really the same as member? 
        public HSBColor FromColor_(Color color) {
            float r = color.r;
            float g = color.g;
            float b = color.b;
            a = color.a;

            float max = Mathf.Max(r, Mathf.Max(g, b));

            if (max <= 0) {
                return this;
            }

            float min = Mathf.Min(r, Mathf.Min(g, b));
            float dif = max - min;

            if (max > min) {
                if (g == max) {
                    h = (b - r) / dif * 60f + 120f;
                }
                else if (b == max) {
                    h = (r - g) / dif * 60f + 240f;
                }
                else if (b > g) {
                    h = (g - b) / dif * 60f + 360f;
                }
                else {
                    h = (g - b) / dif * 60f;
                }
                if (h < 0) {
                    h = h + 360f;
                }
            }
            else {
                h = 0;
            }

            this.h *= 1f / 360f;
            this.s = (dif / max) * 1f;
            this.b = max;

            return this;
        }

        public static Color ToColor(HSBColor hsbColor) {
            float r = hsbColor.b;
            float g = hsbColor.b;
            float b = hsbColor.b;
            if (hsbColor.s != 0) {
                float max = hsbColor.b;
                float dif = hsbColor.b * hsbColor.s;
                float min = hsbColor.b - dif;

                float h = hsbColor.h * 360f;

                if (h < 60f) {
                    r = max;
                    g = h * dif / 60f + min;
                    b = min;
                }
                else if (h < 120f) {
                    r = -(h - 120f) * dif / 60f + min;
                    g = max;
                    b = min;
                }
                else if (h < 180f) {
                    r = min;
                    g = max;
                    b = (h - 120f) * dif / 60f + min;
                }
                else if (h < 240f) {
                    r = min;
                    g = -(h - 240f) * dif / 60f + min;
                    b = max;
                }
                else if (h < 300f) {
                    r = (h - 240f) * dif / 60f + min;
                    g = min;
                    b = max;
                }
                else if (h <= 360f) {
                    r = max;
                    g = min;
                    b = -(h - 360f) * dif / 60 + min;
                }
                else {
                    r = 0;
                    g = 0;
                    b = 0;
                }
            }

            return new Color(Mathf.Clamp01(r), Mathf.Clamp01(g), Mathf.Clamp01(b), hsbColor.a);
        }

        public Color ToColor() {
            return ToColor(this);
        }

        public override string ToString() {
            return "HSBA(" + h + ", " + s + ", " + b + ", " + a+")";
        }

        public static HSBColor operator +(HSBColor a, HSBColor b)
        {
            HSBColor dest = new HSBColor(
               Mathf.Min(a.h + b.h, 255),
               Mathf.Min(a.s + b.s, 255),
               Mathf.Min(a.b + b.b, 255),
               Mathf.Min(a.a + b.a, 255));
            return dest;
        }

        public static HSBColor operator -(HSBColor a, HSBColor b)
        {
            HSBColor dest = new HSBColor(
               Mathf.Min(a.h - b.h, 255),
               Mathf.Min(a.s - b.s, 255),
               Mathf.Min(a.b - b.b, 255),
               Mathf.Min(a.a - b.a, 255));
            return dest;
        }

        public static HSBColor Lerp(HSBColor a, HSBColor b, float t) {
            float h, s;

            //check special case black (color.b==0): interpolate neither hue nor saturation!
            //check special case grey (color.s==0): don't interpolate hue!
            if (a.b == 0) {
                h = b.h;
                s = b.s;
            }
            else if (b.b == 0) {
                h = a.h;
                s = a.s;
            }
            else {
                if (a.s == 0) {
                    h = b.h;
                }
                else if (b.s == 0) {
                    h = a.h;
                }
                else {
                    // works around bug with LerpAngle
                    float angle = Mathf.LerpAngle(a.h * 360f, b.h * 360f, t);
                    while (angle < 0f)
                        angle += 360f;
                    while (angle > 360f)
                        angle -= 360f;
                    h = angle / 360f;
                }
                s = Mathf.Lerp(a.s, b.s, t);
            }
            return new HSBColor(h, s, Mathf.Lerp(a.b, b.b, t), Mathf.Lerp(a.a, b.a, t));
        }
        
    }
}