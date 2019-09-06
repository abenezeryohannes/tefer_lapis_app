@extends('layouts.app')

@section('content')
    <div class="row justify-content-center">
        <div class="col-md-8">



        @foreach($advisors as $adv)
                                    
            <div class="card" style="width: 18rem;">
                 <div class="card-body">
                        <h5 class="card-title">{{$adv->user->name}}</h5>
                        <h6 class="card-subtitle mb-2 text-muted">{{$adv->user->email}}</h6>
                            <p class="card-text">Some quick example text to build on the card title and make up the bulk of the card's content.</p>
                                <a href="#" class="card-link">Apply</a>
                                <a href="#" class="card-link">Another link</a>
                </div>
            </div>                   
        @endforeach



		</div>
	</div>





@endsection
