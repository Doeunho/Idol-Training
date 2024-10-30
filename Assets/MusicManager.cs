using UnityEngine;
using UnityEngine.UI;
using System.Collections.Generic;
using System.Linq;
using Palmmedia.ReportGenerator.Core;

public class MusicManager : MonoBehaviour
{
    [SerializeField] private string musicDataPath = "Music";
    [SerializeField] private TrainingDataManager trainingDataManager;
    private MusicData pixelWorldMusic;
    private List<MusicData> availableMusic;

    private void Awake()
    {
        LoadMusicData();
    }

    private void LoadMusicData()
    {
        MusicData[] allMusic = Resources.LoadAll<MusicData>(musicDataPath);
        pixelWorldMusic = allMusic.FirstOrDefault(m => m.name == "Music_PixelWorld");
        availableMusic = allMusic.Where(m => m != pixelWorldMusic).ToList();
    }

    public void AssignMusicToProgram(GameObject programUI, bool isStretch)
    {
        Music musicComponent = programUI.GetComponent<Music>();
        if (musicComponent == null) return;

        if (isStretch)
        {
            musicComponent._musicData = pixelWorldMusic;
        }
        else
        {
            int randomIndex = Random.Range(0, availableMusic.Count);
            musicComponent._musicData = availableMusic[randomIndex];
            availableMusic.RemoveAt(randomIndex);
        }
    }
}
