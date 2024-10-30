using UnityEngine;
using UnityEngine.UI;
using System.Collections.Generic;
using System.Linq;
using Palmmedia.ReportGenerator.Core;

public class MusicManager : MonoBehaviour
{
    [Header("Settings")]
    [SerializeField] private string musicDataPath = "Music";

    private MusicData pixelWorldMusic;
    private List<MusicData> availableMusic;
    private bool isInitialized = false;

    private void Awake()
    {
        LoadMusicData();
    }

    private void LoadMusicData()
    {
        if (isInitialized) return;

        Debug.Log("음악 데이터 로딩 시작...");
        availableMusic = new List<MusicData>();

        MusicData[] allMusic = Resources.LoadAll<MusicData>(musicDataPath);
        if (allMusic == null || allMusic.Length == 0)
        {
            Debug.LogError($"{musicDataPath} 경로에서 음악을 불러오지 못했습니다!");
            return;
        }

        pixelWorldMusic = allMusic.FirstOrDefault(m => m.name == "Music_PixelWorld");
        if (pixelWorldMusic == null)
        {
            Debug.LogError("PixelWorld 음악을 찾을 수 없습니다!");
            return;
        }

        availableMusic = allMusic.Where(m => m != pixelWorldMusic).ToList();
        isInitialized = true;
        Debug.Log($"음악 데이터 로딩 완료. PixelWorld 음악: {pixelWorldMusic.name}");
    }

    public void AssignMusicToProgram(GameObject programUI, bool isStretch)
    {
        if (!isInitialized)
        {
            LoadMusicData();
        }

        if (programUI == null)
        {
            Debug.LogError("프로그램 UI가 null입니다!");
            return;
        }

        Music musicComponent = programUI.GetComponentInChildren<Music>();
        if (musicComponent == null)
        {
            Debug.LogError($"{programUI.name}에서 Music 컴포넌트를 찾을 수 없습니다!");
            return;
        }

        if (isStretch)
        {
            if (pixelWorldMusic == null)
            {
                Debug.LogError("PixelWorld 음악이 null입니다!");
                return;
            }
            musicComponent._musicData = pixelWorldMusic;
            Debug.Log($"{programUI.name}에 PixelWorld 음악이 할당되었습니다");
        }
        else
        {
            if (availableMusic.Count == 0)
            {
                LoadMusicData(); // 사용 가능한 음악 리스트 재설정
            }

            int randomIndex = Random.Range(0, availableMusic.Count);
            musicComponent._musicData = availableMusic[randomIndex];
            Debug.Log($"{programUI.name}에 랜덤 음악({availableMusic[randomIndex].name})이 할당되었습니다");
            availableMusic.RemoveAt(randomIndex);
        }
    }
}