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

        Debug.Log("���� ������ �ε� ����...");
        availableMusic = new List<MusicData>();

        MusicData[] allMusic = Resources.LoadAll<MusicData>(musicDataPath);
        if (allMusic == null || allMusic.Length == 0)
        {
            Debug.LogError($"{musicDataPath} ��ο��� ������ �ҷ����� ���߽��ϴ�!");
            return;
        }

        pixelWorldMusic = allMusic.FirstOrDefault(m => m.name == "Music_PixelWorld");
        if (pixelWorldMusic == null)
        {
            Debug.LogError("PixelWorld ������ ã�� �� �����ϴ�!");
            return;
        }

        availableMusic = allMusic.Where(m => m != pixelWorldMusic).ToList();
        isInitialized = true;
        Debug.Log($"���� ������ �ε� �Ϸ�. PixelWorld ����: {pixelWorldMusic.name}");
    }

    public void AssignMusicToProgram(GameObject programUI, bool isStretch)
    {
        if (!isInitialized)
        {
            LoadMusicData();
        }

        if (programUI == null)
        {
            Debug.LogError("���α׷� UI�� null�Դϴ�!");
            return;
        }

        Music musicComponent = programUI.GetComponentInChildren<Music>();
        if (musicComponent == null)
        {
            Debug.LogError($"{programUI.name}���� Music ������Ʈ�� ã�� �� �����ϴ�!");
            return;
        }

        if (isStretch)
        {
            if (pixelWorldMusic == null)
            {
                Debug.LogError("PixelWorld ������ null�Դϴ�!");
                return;
            }
            musicComponent._musicData = pixelWorldMusic;
            Debug.Log($"{programUI.name}�� PixelWorld ������ �Ҵ�Ǿ����ϴ�");
        }
        else
        {
            if (availableMusic.Count == 0)
            {
                LoadMusicData(); // ��� ������ ���� ����Ʈ �缳��
            }

            int randomIndex = Random.Range(0, availableMusic.Count);
            musicComponent._musicData = availableMusic[randomIndex];
            Debug.Log($"{programUI.name}�� ���� ����({availableMusic[randomIndex].name})�� �Ҵ�Ǿ����ϴ�");
            availableMusic.RemoveAt(randomIndex);
        }
    }
}