using UnityEngine;
using UnityEngine.UI;
using Cysharp.Threading.Tasks;
using System.Threading;
using UnityEditor;
using Cysharp.Threading.Tasks.CompilerServices;
using System;

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
        try
        {
            if (Btn_GameStart == null)
            {
                Btn_GameStart = gameObject.AddComponent<Button>();
            }
            buttonImage = Btn_GameStart.GetComponent<Image>();
            if (buttonImage != null)
            {
                cts = new CancellationTokenSource();
                Btn_GameStart.onClick.AddListener(OnButtonClick);

                // GetCancellationTokenOnDestroy()를 사용하여 자동 취소 처리
                await FadeButtonAsync(this.GetCancellationTokenOnDestroy());
            }
            else
            {
                Debug.LogError("버튼이미지를 찾을수 없다.");
            }
        }
        catch (OperationCanceledException)
        {
            // 작업 취소 시 정상적으로 처리
            Debug.Log("FadeButton operation was canceled");
        }
        catch (System.Exception ex)
        {
            Debug.LogError($"Error in Start: {ex}");
        }
    }

    private void OnDisable()
    {
        if (Btn_GameStart != null)
        {
            Btn_GameStart.onClick.RemoveListener(OnButtonClick);
        }

        if (cts != null)
        {
            cts.Cancel();
            cts.Dispose();
            cts = null;
        }
    }

    private void OnButtonClick()
    {
        HandleButtonClickAsync().Forget();
    }

    private async UniTaskVoid HandleButtonClickAsync()
    {
        try
        {
            await UniTask.Delay(100, cancellationToken: this.GetCancellationTokenOnDestroy());
            Debug.Log("Button clicked!");
        }
        catch (OperationCanceledException)
        {
            Debug.Log("Button click operation was canceled");
        }
    }

    async UniTask FadeButtonAsync(CancellationToken cancellationToken)
    {
        try
        {
            while (!cancellationToken.IsCancellationRequested)
            {
                await FadeButton(minAlpha, cancellationToken);
                await FadeButton(maxAlpha, cancellationToken);
            }
        }
        catch (OperationCanceledException)
        {
            Debug.Log("FadeButton operation was canceled");
        }
    }

    async UniTask FadeButton(float btnAlpfa, CancellationToken cancellationToken)
    {
        Color startColor = buttonImage.color;
        Color endColor = new Color(startColor.r, startColor.g, startColor.b, btnAlpfa);
        float elapsedTime = 0f;

        try
        {
            while (elapsedTime < fadeDuration)
            {
                elapsedTime += Time.deltaTime;
                float t = elapsedTime / fadeDuration;
                buttonImage.color = Color.Lerp(startColor, endColor, t);
                await UniTask.Yield(PlayerLoopTiming.Update, cancellationToken);
            }
            buttonImage.color = endColor;
        }
        catch (OperationCanceledException)
        {
            Debug.Log("Fade operation was canceled");
            throw; // 상위로 예외를 전파
        }
    }
}