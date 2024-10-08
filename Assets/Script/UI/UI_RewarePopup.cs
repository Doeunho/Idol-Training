using UnityEngine;
using UnityEngine.UI;
using TMPro;
using Cysharp.Threading.Tasks;
using DG.Tweening;
using System;

public class UI_RewarePopup : MonoBehaviour
{
    [SerializeField] private RectTransform parentUI;
    [SerializeField] private RectTransform topUI;
    [SerializeField] private RectTransform bottomUI;
    [SerializeField] private RectTransform rankUI;
    [SerializeField] private RectTransform rewardUI;

    [SerializeField] private Slider rankSlider;
    [SerializeField] private Text rankText;

    [SerializeField] private float topUIDelay;
    [SerializeField] private float topUIAnimationDuration;
    [SerializeField] private float bottomUIDelay;
    [SerializeField] private float bottomUIAnimationDuration;
    [SerializeField] private float rankRewardFadeInDuration;
    [SerializeField] private float rankSliderAnimationDuration = 1f;
    [SerializeField] private float resetDelay = 0.5f;
    [SerializeField] private float checkImageAnimationDuration = 0.5f; // 체크 이미지 애니메이션 시간

    [SerializeField] private Image checkImage; // 체크 이미지

    private CanvasGroup topUICanvasGroup;
    private CanvasGroup rankUICanvasGroup;
    private CanvasGroup rewardUICanvasGroup;
    private Vector2 topUIOriginalPosition;
    private Vector2 topUIOriginalAnchorMin;
    private Vector2 topUIOriginalAnchorMax;
    private bool isAnimating = false;

    private void OnEnable()
    {
        SetupCanvasGroups();
        AnimateUIAsync().Forget();
    }

    private void OnDisable()
    {
        isAnimating = false;
    }

    private void InitializeUI()
    {
        // 초기 설정
        topUI.gameObject.SetActive(false);
        bottomUI.gameObject.SetActive(false);
        rankUI.gameObject.SetActive(false);
        rewardUI.gameObject.SetActive(false);
        topUICanvasGroup.alpha = 0f;
        rankUICanvasGroup.alpha = 0f;
        rewardUICanvasGroup.alpha = 0f;

        rankSlider.value = 0f;
        UpdateRankText(0);

        SetupTopUI();

        if (checkImage != null)
        {
            checkImage.transform.localScale = Vector3.zero;
            checkImage.gameObject.SetActive(false);
        }
    }
    private bool IsUIValid()
    {
        return this != null && rankSlider != null && rankText != null;
    }

    private void SetupCanvasGroups()
    {
        topUICanvasGroup = GetOrAddCanvasGroup(topUI);
        rankUICanvasGroup = GetOrAddCanvasGroup(rankUI);
        rewardUICanvasGroup = GetOrAddCanvasGroup(rewardUI);
    }

    private CanvasGroup GetOrAddCanvasGroup(RectTransform rectTransform)
    {
        var canvasGroup = rectTransform.GetComponent<CanvasGroup>();
        if (canvasGroup == null)
            canvasGroup = rectTransform.gameObject.AddComponent<CanvasGroup>();
        return canvasGroup;
    }

    private async UniTaskVoid AnimateUIAsync()
    {
        if (!IsUIValid()) return;

        InitializeUI();

        await UniTask.Delay(TimeSpan.FromSeconds(topUIDelay));

        if (!IsUIValid()) return;
        await AnimateTopUI();
        await AnimateCheckImage();

        await UniTask.Delay(TimeSpan.FromSeconds(bottomUIDelay));

        if (!IsUIValid()) return;
        await AnimateBottomUI();

        if (!IsUIValid()) return;
        await AnimateRankAndRewardUI();

        if (IsUIValid())
        {
            await AnimateRankSlider();
            
        }
    }

    private void SetupTopUI()
    {
        topUIOriginalPosition = topUI.anchoredPosition;
        topUIOriginalAnchorMin = topUI.anchorMin;
        topUIOriginalAnchorMax = topUI.anchorMax;
        topUI.anchorMin = topUI.anchorMax = new Vector2(0.5f, 0.5f);
        topUI.anchoredPosition = Vector2.zero;
    }

    private async UniTask AnimateTopUI()
    {
        topUI.gameObject.SetActive(true);
        await DOTween.Sequence()
            .Join(topUICanvasGroup.DOFade(1f, topUIAnimationDuration))
            .Join(DOTween.To(() => topUI.anchorMin, x => topUI.anchorMin = x, topUIOriginalAnchorMin, topUIAnimationDuration))
            .Join(DOTween.To(() => topUI.anchorMax, x => topUI.anchorMax = x, topUIOriginalAnchorMax, topUIAnimationDuration))
            .Join(topUI.DOAnchorPos(topUIOriginalPosition, topUIAnimationDuration))
            .SetEase(Ease.InOutSine)
            .AsyncWaitForCompletion();
    }

    private async UniTask AnimateBottomUI()
    {
        bottomUI.gameObject.SetActive(true);
        bottomUI.anchorMin = new Vector2(0.5f, 1f);
        bottomUI.anchorMax = new Vector2(0.5f, 1f);
        bottomUI.pivot = new Vector2(0.5f, 1f);

        float topUIBottom = topUI.anchoredPosition.y - topUI.rect.height;
        bottomUI.anchoredPosition = new Vector2(0, topUIBottom);

        float originalHeight = bottomUI.rect.height;
        bottomUI.sizeDelta = new Vector2(bottomUI.sizeDelta.x, 0);

        await bottomUI.DOSizeDelta(new Vector2(bottomUI.sizeDelta.x, originalHeight), bottomUIAnimationDuration)
            .SetEase(Ease.OutBack)
            .AsyncWaitForCompletion();
    }

    private async UniTask AnimateRankAndRewardUI()
    {
        rankUI.gameObject.SetActive(true);
        rewardUI.gameObject.SetActive(true);

        await DOTween.Sequence()
            .Join(rankUICanvasGroup.DOFade(1f, rankRewardFadeInDuration))
            .Join(rewardUICanvasGroup.DOFade(1f, rankRewardFadeInDuration))
            .SetEase(Ease.InOutSine)
            .AsyncWaitForCompletion();
    }

    private async UniTask AnimateRankSlider()
    {
        if (!IsUIValid()) return;

        float startValue = 0f;
        float endValue = rankSlider.maxValue;
        float elapsedTime = 0f;

        rankSlider.value = startValue;
        UpdateRankText(Mathf.RoundToInt(startValue));

        while (elapsedTime < rankSliderAnimationDuration && IsUIValid())
        {
            elapsedTime += Time.deltaTime;
            float t = elapsedTime / rankSliderAnimationDuration;
            float currentValue = Mathf.Lerp(startValue, endValue, t);

            if (rankSlider != null)
            {
                rankSlider.value = currentValue;
                UpdateRankText(Mathf.RoundToInt(currentValue));
            }

            await UniTask.Yield();
        }

        if (IsUIValid())
        {
            rankSlider.value = endValue;
            UpdateRankText(Mathf.RoundToInt(endValue));
        }
    }

    private void UpdateRankText(int value)
    {
        if (rankText != null) rankText.text = $"{value:00}";
    }

    private void ResetRankSlider()
    {
        if (rankSlider != null)
        {
            rankSlider.value = 0f;
            UpdateRankText(0);
        }
    }

    private async UniTask AnimateCheckImage()
    {
        if (checkImage != null)
        {
            checkImage.gameObject.SetActive(true);
            await checkImage.transform.DOScale(Vector3.one, checkImageAnimationDuration)
                .SetEase(Ease.OutBack)
                .AsyncWaitForCompletion();
        }
    }
}