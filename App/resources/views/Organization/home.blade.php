@extends('layouts.app')

@section('content')
        <div class="row justify-content-center" style="margin-bottom:30px;">
            <div class="col-md-8">




        @foreach($posts as $post)
                            <!-- Card Narrower -->
                <div class="card card-cascade narrower" 
                style="
                        width: 50%;
                        margin-bottom: 20px;                    
                        display: block;
                        margin-left: auto;
                        margin-right: auto;
                        ">

                <!-- Card content -->
                <div class="card-body card-body-cascade">

                    <!-- Label -->
                    <h5 class="pink-text pb-2 pt-1"><i class="fas fa-utensils"></i>
                            {{ $post->poster->name}}
                    </h5>
                    <!-- Title -->
                    <h4 class="font-weight-bold card-title">
                            {{$post->work_area}}
                    </h4>

                        <ul class="list-group" style="display: inline-block">
                            <li class="list-group-item" style="display: inline-block; border: none">
                            Number of students: 
                            {{ $post->student_no }}
                            
                            </li>
                            <li class="list-group-item" style="display: inline-block; border: none">
                            Minimum grade:
                            {{ $post->min_grade }}
                            
                            </li>
                            {{-- <li class="list-group-item list-group-item-info">{{App\User::find($post->department)->name}}</li> --}}
                        </ul>
                    <!-- Text -->
                    <p class="card-text">
                    {{-- {{/*$post->description */}} --}}
                    Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi.
                    
                    </p>
                    <!-- Button -->
                   <a href="#ApplyModal" class="btn btn-success" data-toggle="modal"> 
                   <span>Apply</span>
                   </a>
						
                </div>

                <!-- Card footer -->
                <div class="card-footer text-muted text-center">
                    {{App\Http\Controllers\Util::to_time_ago($post->created_at)}}
                </div>

        </div>    
@endforeach







		</div>
	</div>



    
<!-- Edit Modal HTML -->
	<div id="ApplyModal" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content">
				<form>
					<div class="modal-header">						
						<h4 class="modal-title">Rquest Internship</h4>
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					</div>
					<div class="modal-body">					
						<div class="form-group">
							<label>Write Something (optional)</label>
							<textarea type="text" class="form-control">
                            </textarea>
						</div>
						<div class="form-group">
							<label>Attachments  (optional)</label>
							<input type="file" class="form-control" >
						</div>
                      			
					</div>
					<div class="modal-footer">
						<input type="button" class="btn btn-default" data-dismiss="modal" value="Cancel">
						<a type="submit" class="btn btn-success" value="Apply" style="text-color:white;">
                        Apply
                        </a>
					</div>
				</form>
			</div>
		</div>
	</div>


@endsection
