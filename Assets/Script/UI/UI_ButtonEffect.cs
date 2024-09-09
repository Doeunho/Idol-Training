using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UI_ButtonEffects : MonoBehaviour
{
    [SerializeField] private Button Btn_GameStart;
    [SerializeField] private float fadeDuration = 1f;
    [SerializeField] private float minAlpha = 0.5f;
    [SerializeField] private float maxAlpha = 1f;

    [SerializeField] private Image buttonImage;
}
