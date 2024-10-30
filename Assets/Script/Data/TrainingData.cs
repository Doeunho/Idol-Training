using Autodesk.Fbx;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[CreateAssetMenu(menuName = "TrainingData")]
public class TrainingData : ScriptableObject
{
    public Sprite trainingIcon;
    public string exerciseName;
    public ExerciseType exerciseType;
    public CameraHeight cameraHeight;

    public string trainingName;
    public RuntimeAnimatorController trainingController;

    public enum ExerciseType
    {
        Abdomen,
        Arm,
        Leg,
        Wholebody,
        Strech
    }

    public enum CameraHeight
    {
        Up,
        Down
    }
}
