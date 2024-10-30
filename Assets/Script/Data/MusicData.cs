using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
[CreateAssetMenu(menuName = "MusicData")]
public class MusicData : ScriptableObject
{
    public enum MusicName { WaitforYou, PixelWorld, Why, SixSummer, Loveme, OurMovie, IJustLoveYa, MerryPLLIstmas, WayForLuv, PumpUpTheVolume }

    public MusicName musicName;
    public AudioClip Music;
    public Sprite Img_MusicImg;
    public string Text_MusicName;
    public int Musicid;
}
