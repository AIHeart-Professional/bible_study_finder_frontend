import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { ReactiveFormsModule, FormBuilder, FormGroup, FormControl, Validators } from '@angular/forms';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [CommonModule, RouterLink, ReactiveFormsModule],
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit {
  searchForm!: FormGroup;
  
  // Search criteria options
  studyTypes = [
    { value: '', label: 'Any Study Type' },
    { value: 'bible-study', label: 'Bible Study' },
    { value: 'book-study', label: 'Book Study' },
    { value: 'topical', label: 'Topical Study' },
    { value: 'verse-by-verse', label: 'Verse by Verse' },
    { value: 'womens', label: "Women's Study" },
    { value: 'mens', label: "Men's Study" },
    { value: 'youth', label: 'Youth Study' },
    { value: 'seniors', label: 'Seniors Study' }
  ];

  meetingDays = [
    { value: '', label: 'Any Day' },
    { value: 'sunday', label: 'Sunday' },
    { value: 'monday', label: 'Monday' },
    { value: 'tuesday', label: 'Tuesday' },
    { value: 'wednesday', label: 'Wednesday' },
    { value: 'thursday', label: 'Thursday' },
    { value: 'friday', label: 'Friday' },
    { value: 'saturday', label: 'Saturday' }
  ];

  meetingTimes = [
    { value: '', label: 'Any Time' },
    { value: 'morning', label: 'Morning (6AM - 12PM)' },
    { value: 'afternoon', label: 'Afternoon (12PM - 6PM)' },
    { value: 'evening', label: 'Evening (6PM - 10PM)' }
  ];

  ageGroups = [
    { value: '', label: 'Any Age Group' },
    { value: 'teens', label: 'Teens (13-17)' },
    { value: 'young-adults', label: 'Young Adults (18-30)' },
    { value: 'adults', label: 'Adults (31-55)' },
    { value: 'seniors', label: 'Seniors (55+)' },
    { value: 'mixed', label: 'Mixed Ages' }
  ];

  languages = [
    { value: '', label: 'Any Language' },
    { value: 'english', label: 'English' },
    { value: 'spanish', label: 'Spanish' },
    { value: 'korean', label: 'Korean' },
    { value: 'chinese', label: 'Chinese' },
    { value: 'portuguese', label: 'Portuguese' },
    { value: 'french', label: 'French' }
  ];

  constructor(private fb: FormBuilder) {}

  ngOnInit() {
    this.initializeForm();
  }

  initializeForm() {
    this.searchForm = this.fb.group({
      searchTerm: ['', [Validators.maxLength(100)]],
      location: ['', [Validators.maxLength(100)]],
      studyType: [''],
      meetingDay: [''],
      meetingTime: [''],
      ageGroup: [''],
      language: [''],
      maxDistance: [25, [Validators.min(1), Validators.max(100)]], // in miles
      groupSize: [50, [Validators.min(5), Validators.max(100)]], // max group size
      isOnline: [false],
      isInPerson: [true],
      isChildcareAvailable: [false],
      isBeginnersWelcome: [true]
    });
  }

  onSearch() {
    if (this.searchForm.valid) {
      const searchCriteria = this.searchForm.value;
      console.log('Search criteria:', searchCriteria);
      
      // Basic validation: ensure at least one meeting type is selected
      if (!searchCriteria.isOnline && !searchCriteria.isInPerson) {
        alert('Please select at least one meeting type (Online or In-person).');
        return;
      }

      // TODO: Implement search logic
      // This would typically call a service to search for Bible study groups
      alert('Search functionality will be implemented when connected to a backend service.');
    } else {
      console.log('Form is invalid');
      this.markFormGroupTouched();
    }
  }

  private markFormGroupTouched() {
    Object.keys(this.searchForm.controls).forEach(key => {
      const control = this.searchForm.get(key);
      if (control) {
        control.markAsTouched();
      }
    });
  }

  onReset() {
    this.initializeForm();
  }

  // Helper methods for form validation and display
  isFieldInvalid(fieldName: string): boolean {
    const field = this.searchForm.get(fieldName);
    return field ? field.invalid && (field.dirty || field.touched) : false;
  }

  getFieldError(fieldName: string): string {
    const field = this.searchForm.get(fieldName);
    if (field && field.errors) {
      if (field.errors['maxlength']) {
        return `Maximum ${field.errors['maxlength'].requiredLength} characters allowed`;
      }
      if (field.errors['min']) {
        return `Minimum value is ${field.errors['min'].min}`;
      }
      if (field.errors['max']) {
        return `Maximum value is ${field.errors['max'].max}`;
      }
    }
    return '';
  }

  // Helper method to get slider display values
  getDistanceDisplay(value: number): string {
    return value >= 100 ? '100+ miles' : `${value} miles`;
  }

  getGroupSizeDisplay(value: number): string {
    return value >= 100 ? '100+ people' : `${value} people`;
  }
}
