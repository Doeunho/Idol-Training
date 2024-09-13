using UnityEngine;
using UnityEngine.UI;
using Cysharp.Threading.Tasks;
using System.Threading;
using UnityEditor;
using Cysharp.Threading.Tasks.CompilerServices;

public class UI_ButtonEffects : MonoBehaviour
{
    [SerializeField] private Button Btn_GameStart;
    [SerializeField] private float fadeDuration = 1f;
    [SerializeField] private float minAlpha = 0.5f;
    [SerializeField] private float maxAlpha = 1f;

    [SerializeField] private Image buttonImage;
    [SerializeField] private CancellationTokenSource cts;


    async void Start()
    {
        if (Btn_GameStart == null)
        {
            Btn_GameStart = gameObject.AddComponent<Button>();
        }

        buttonImage = Btn_GameStart.GetComponent<Image>();
        if (buttonImage != null )
        {
            cts = new CancellationTokenSource();
            await FadeButtonAsync(cts.Token);
        }
        else
        {
            Debug.LogError("��ư�̹����� ã���� ����.");
        }
    }

    private void OnDestroy()
    {
        cts?.Cancel(); //��ҽ�ȣ
        cts?.Dispose(); //���ҽ� ���� , �� ��� �� ���ҽ� ����(���� �߿�)
    }

    async UniTask FadeButtonAsync(CancellationToken cancellationToken)
    {
        while(!cancellationToken.IsCancellationRequested)
        {
            await FadeButton(minAlpha, cancellationToken);
            await FadeButton(maxAlpha, cancellationToken);
        }
    }

    async UniTask FadeButton(float btnAlpfa, CancellationToken cancellationToken)
    {
        Color startColor = buttonImage.color;
        Color endColor = new Color(startColor.r, startColor.g, startColor.b, btnAlpfa);
        float elapsedTime = 0f;

        while (elapsedTime < fadeDuration)
        {
            elapsedTime += Time.deltaTime;
            float t = elapsedTime / fadeDuration;
            buttonImage.color = Color.Lerp(startColor, endColor, t);
            await UniTask.Yield(PlayerLoopTiming.Update, cancellationToken);
        }
        buttonImage.color = endColor;
    }
}
