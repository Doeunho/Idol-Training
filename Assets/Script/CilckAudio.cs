using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CilckAudio : MonoBehaviour
{
    [SerializeField] AudioSource ButtonAudioSource;

    AudioSource audioSource;
    private void Awake()
    {
        audioSource = GetComponent<AudioSource>();
    }
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetMouseButtonUp(0))
        {
            audioSource.Play();
        }
        if(ButtonAudioSource.isPlaying)
        {
            audioSource.Stop();
        }
    }
}
